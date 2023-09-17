//
//  AddSensorView.swift
//  AquaTerra
//
//  Created by Davincci on 13/9/2023.
//
import SwiftUI
import MapKit
import CoreLocation

struct AddSensorView: View {
    @ObservedObject var viewModel: SessionViewViewModel
    @Binding var showAddSensorSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    let fieldID: String
    @State private var selectPosion: CLLocationCoordinate2D?

    @State private var sensorID: String = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var annotations: [MKPointAnnotation] = []
    @State private var FullScreen = true
    @State private var selected = 0
    
    private var enableBtn : Binding<Bool> {
        Binding<Bool>(
            get: {
                return selectedCoordinate != nil
            },
            set: { _ in}
        )
    }

    var body: some View {
        NavigationView {
            VStack{
                FMNavigationBarView(title: "Add A New Sensor")
                    .frame(height: 45)
                Divider()
                SensorStepView(selected: $selected).padding(.vertical, 20)
                
                
                VStack{
                    switch selected {
                    case 0:
                        VStack(alignment: .leading){
                            HStack(spacing: 3.5){
                                Text("Please enter your new sensor ID.")
                                    .font(.custom("OpenSans-SemiBold", size: 16)).frame(alignment: .leading)
                            }
                            
                            TextField("Example:AquaTerraGateway909a56",text: $sensorID)
                                .font(.custom("OpenSans-Regular", size: 14))
                                .foregroundColor(Color("Placeholder"))
                                .padding([.horizontal], 15)
                                .frame(height: 50)
                                .accentColor(Color("ButtonGradient2"))
                                .background(Color("Hint"))
                                .cornerRadius(5)
                            
                        }.padding(.horizontal, 30)
                            .padding(.top, 20)
                        
                        SensorButton(title: "Next") {
                            next()
                        }
                        .frame(height: 50)
                        .padding(.top, 15)
                        .padding(.horizontal,30)
                        
                        Spacer()
                        
                    case 1:
                        GRMapView(
                            fullScreen: $FullScreen,
                            selectPosion: $selectedCoordinate,
                            annotations: $annotations
                        )
                        .padding(.horizontal, 30)
                        
                        HStack{
                            SensorButton(title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                undo()
                                presentationMode.wrappedValue.dismiss()
                            })
                            Spacer().frame(width: 20)
                            GRButton(enable:enableBtn, title: "Next") {
                                next()
                            }
                        }
                        .frame(height: 60)
                        .padding(.top, 15)
                        .padding(.horizontal, 30)
                        Spacer()
                    
                    case 2:
                        SensorSubmitView(gateway: sensorID) {
                            guard let selectedCoordinate = selectedCoordinate else {
                                return
                            }

                            print("Selected Coordinate: \(selectedCoordinate.latitude), \(selectedCoordinate.longitude)")
                            
                            SensorListApi.shared.createSensor(sensorID: sensorID, fieldID: fieldID, coordinate: selectedCoordinate) { result in
                                switch result {
                                case .success:
                                    showAddSensorSheet = false
                                case .failure(let error):
                                    print("Error creating sensor: \(error)")
                                }
                            }
                        } .padding(.horizontal, 30)
                            .padding(.top,20)
                            Spacer()
                    
                    default :
                        HStack{}
                    }
                    
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationBackView()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 70,height: 17)
                }
            }
            .navigationBarBackButtonHidden(true)
    }
    private func undo() {
        selectPosion = nil
        annotations.removeAll()
    }
    
    private func next(){
        withAnimation(.linear(duration: 0.5)){
            selected += 1
        }
    }
    
}

