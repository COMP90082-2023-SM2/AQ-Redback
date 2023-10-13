//
//  FarmRegisterView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI
import MapKit

struct FarmRegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: FarmsViewModel

    @State private var step: Int = 0
    @State private var mapFullScreen = false
    @State private var polyLineLocations: [CLLocation] = []
    @State private var drawPolylineFinished: Bool = false

    private var farmAndFieldNameReady: Binding<Bool> {
        Binding<Bool>(
            get: {
                return !self.viewModel.newFarm.name.isEmpty && !self.viewModel.newFarm.fieldName.isEmpty
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
            FMNavigationBarView(title: "Select a Field")
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
                            FarmRegisterInfoView(viewModel: viewModel, enable: farmAndFieldNameReady, clickAction: {
                                
                                withAnimation(.linear(duration: 0.5)) {
                                        step += 1
                                }
                            })
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
                                Text("to outline your field.")
                                    .font(.custom("OpenSans-Regular", size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                            })
                            
                            Text("• The field must be within 1000 metres from the gateway.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
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
                            Spacer()
                        case 2:
                            FarmRegisterSubmitView(viewModel: viewModel) {
                                
                                onRegisterField()
                            }
                            .padding(.top,20)
                        default :
                            HStack{}
                        }
                    }
                    .padding(.leading,30)
                    .padding(.trailing,30)
                    Spacer()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Farm Registration")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 70,height: 17)
            }
        }
    }
    
    private func undo() {
        polyLineLocations.removeAll()
    }

    func onRegisterField() {
        
        guard !polyLineLocations.isEmpty else {
            return
        }
                
        viewModel.newFarm.polyLineLocations = polyLineLocations.map({ [$0.coordinate.longitude, $0.coordinate.latitude] })
        
        viewModel.registerField()
        
        withAnimation(.linear(duration: 0.5)) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct FarmRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        FarmRegisterView(viewModel: FarmsViewModel.previewViewModel())
    }
}
