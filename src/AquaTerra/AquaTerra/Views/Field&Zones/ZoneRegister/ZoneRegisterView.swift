//
//  ZoneRegisterView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/10.
//

import SwiftUI
import MapKit
import SimpleToast

// Enum to represent whether the user is adding or editing a zone
enum ZoneModifyType {
    case add
    case edit
}
struct ZoneRegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // Observed object for managing field-related data
    @ObservedObject var viewModel: FieldViewModel

    let modifyType: ZoneModifyType
    @State var toEditZone: Zone?
    
    @State private var step: Int = 0
    @State private var mapFullScreen = false
    @State private var polyLineLocations: [CLLocation] = []
    @State private var drawPolylineFinished: Bool = false
    @State private var showToast = false
    @State private var value = 0
    
    // Configuration options for the toast notification
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdropColor: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    // Computed property to check if zone information is ready for the next step
    private var zoneInfoReady: Binding<Bool> {
        Binding<Bool>(
            get: {
                if modifyType == .add {
                    return !self.viewModel.newZone.name.isEmpty && !self.viewModel.newZone.field.isEmpty
                } else {
                    return !self.viewModel.editZone.name.isEmpty && !self.viewModel.editZone.field.isEmpty
                }
            },
            set: { _ in }
        )
    }
    
    // Computed property to check if polyline locations are ready for the next step
    private var polyLineLocationsReady : Binding<Bool> {
        Binding<Bool>(
            get: {
                return !polyLineLocations.isEmpty && drawPolylineFinished
            },
            set: { _ in}
        )
    }

    var body: some View {
        
        VStack {
            // Custom navigation bar at the top
            FMNavigationBarView(title: modifyType == .add ? "Zone Registration": "Edit Zone")
                .frame(height: 45)
            Spacer()
            
            if mapFullScreen && step == 1 {
                
                // Display the map in full-screen mode
                FarmRegisterMap(mapFullScreen: $mapFullScreen, drawPolylineFinished: $drawPolylineFinished, locations: $polyLineLocations)
                
            } else {

                // Registration steps
                VStack {
                    
                    GRSetpView(steps: ["Info", "Plot", "Submit"], selected: $step)
                    
                    VStack{
                        switch step {
                        case 0:
                            // Step 1: Zone information entry
                            ZoneInfoEditView(viewModel: viewModel, modifyType: modifyType, enable: zoneInfoReady) {
                                withAnimation(.linear(duration: 0.5)) {
                                        step += 1
                                }
                            }
                            .padding(.top, 20)
                        case 1:
                            // Step 2: Drawing a polygon on the map
                            HStack(alignment: .center, content: {
                                Text("• Please draw a polygon to outline your")
                                    .font(.custom("OpenSans-Regular", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)

//                                Image("FarmRegisterMapPolyline")
//                                    .resizable()
//                                    .frame(width: 25, height: 27)
//                                Text("to outline your")
//                                    .font(.custom("OpenSans-Regular", size: 16))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .lineLimit(1)
                            })
                            .padding(.horizontal, 30)

                            Text("zone.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .padding(.horizontal, 30)

                            // Map for drawing the polygon
                            FarmRegisterMap(mapFullScreen: $mapFullScreen, drawPolylineFinished: $drawPolylineFinished, locations: $polyLineLocations)
                                .padding(.horizontal, 30)
                            
                            HStack {
                                // Button to undo drawing
                                GRButton(enable: polyLineLocationsReady, title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                    undo()
                                })
                                Spacer()
                                // Button to proceed to the next step
                                GRButton(enable: polyLineLocationsReady, title: "Next") {
                                    
                                    withAnimation(.linear(duration: 0.5)) {
                                            step += 1
                                    }
                                }
                            }
                            .frame(height: 50)
                            .padding(.top, 15)
                            .padding(.bottom, 50)
                            .padding(.horizontal, 30)
                            Spacer()
                        case 2:
                            // Step 3: Submitting the zone information
                            ZoneRegisterSubmitView(viewModel: viewModel) {
                                
                                onAddOrEditZone()
                            }
                            .padding(.top,20)
                            .padding(.horizontal, 30)
                        default :
                            HStack{}
                        }
                    }
                    Spacer()
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            // Toast notification for successful zone creation
            HStack {
                Text("Successfully Create the Zone!").bold()
            }
            .padding(20)
            .background(Color.green.opacity(1))
            .foregroundColor(Color.white)
            .cornerRadius(14)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Custom back button in the navigation bar
            ToolbarItem(placement: .navigationBarLeading) {
                
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 70,height: 17)
            }
        }
        .onAppear {
            BaseBarModel.share.hidden()

//            prepareZoneData()
            if modifyType == .edit, let editZone = toEditZone {
                viewModel.editZone = ZoneEditable.copyFromZone(editZone)
                viewModel.editZoneOldName = editZone.name
                
                if !editZone.points.isEmpty {
                    let jsonData = editZone.points.data(using: .utf8)!
                    
                    do {
                        let zoneCoordinates = try JSONDecoder().decode(ZoneCoordinates.self, from: jsonData)
                        if let first = zoneCoordinates.coordinates.first {
                            polyLineLocations = first.map({ CLLocation(latitude: $0.first ?? 0.0, longitude: $0.last ?? 0.0) })
                            if polyLineLocations.count > 2 {
                                drawPolylineFinished = true
                            }
                        }
                    } catch {
                        debugPrint("decode editZone points: \(error)")
                    }
                }
            } else {
                viewModel.newZone.user = viewModel.currentUserName
                viewModel.newZone.farm = viewModel.currentField?.farm ?? ""
                viewModel.newZone.field = viewModel.currentField?.name ?? ""
            }
        }
    }
    
    func prepareZoneData() {
        
        
    }
    
    private func undo() {
        polyLineLocations.removeAll()
    }

    func onAddOrEditZone() {
        
        guard !polyLineLocations.isEmpty else {
            return
        }
        
        if modifyType == .edit {
            viewModel.editZone.polyLineLocations = polyLineLocations.map({ [$0.coordinate.longitude, $0.coordinate.latitude] })
            viewModel.editZone(viewModel.editZone, oldZoneName: viewModel.editZoneOldName)
        } else  {
            viewModel.newZone.polyLineLocations = polyLineLocations.map({ [$0.coordinate.longitude, $0.coordinate.latitude] })
            viewModel.addZone(viewModel.newZone)
        }
        showToast.toggle()
        withAnimation(.linear(duration: 0.5)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ZoneRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneRegisterView(viewModel: FieldViewModel.previewViewModel(), modifyType: .add)
    }
}
