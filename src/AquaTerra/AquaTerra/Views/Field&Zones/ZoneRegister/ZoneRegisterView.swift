//
//  ZoneRegisterView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/10.
//

import SwiftUI
import MapKit

enum ZoneModifyType {
    case add
    case edit
}
struct ZoneRegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: FieldViewModel

    let modifyType: ZoneModifyType
    @State var toEditZone: Zone?
    
    @State private var step: Int = 0
    @State private var mapFullScreen = false
    @State private var polyLineLocations: [CLLocation] = []
    @State private var drawPolylineFinished: Bool = false

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
            FMNavigationBarView(title: modifyType == .add ? "Zone Registration": "Edit Zone")
                .frame(height: 45)
            Spacer()
            
            if mapFullScreen && step == 1 {
                
                FarmRegisterMap(mapFullScreen: $mapFullScreen, drawPolylineFinished: $drawPolylineFinished, locations: $polyLineLocations)
                
            } else {

                VStack {
                    
                    GRSetpView(steps: ["Info", "Plot", "Submit"], selected: $step)
                    
                    VStack{
                        switch step {
                        case 0:
                            ZoneInfoEditView(viewModel: viewModel, modifyType: modifyType, enable: zoneInfoReady) {
                                withAnimation(.linear(duration: 0.5)) {
                                        step += 1
                                }
                            }
                            .padding(.top, 20)
                        case 1:
                            HStack(alignment: .center, content: {
                                Text("• Please draw a polygon")
                                    .font(.custom("OpenSans-Regular", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)

                                Image("FarmRegisterMapPolyline")
                                    .resizable()
                                    .frame(width: 25, height: 27)
                                Text("to outline your")
                                    .font(.custom("OpenSans-Regular", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                            })
                            .padding(.horizontal, 30)

                            Text("zone.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .padding(.horizontal, 30)

                            FarmRegisterMap(mapFullScreen: $mapFullScreen, drawPolylineFinished: $drawPolylineFinished, locations: $polyLineLocations)
                            
                            HStack {
                                GRButton(enable: polyLineLocationsReady, title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                    undo()
                                })
                                Spacer()
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
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
        
        withAnimation(.linear(duration: 0.5)) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ZoneRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneRegisterView(viewModel: FieldViewModel.previewViewModel(), modifyType: .add)
    }
}
