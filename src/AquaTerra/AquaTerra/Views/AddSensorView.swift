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
    @State var fieldData: [FieldData]
    @State var sensorID: String = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var annotations: [MKPointAnnotation] = []
    @State private var FullScreen = false
    @State private var selected = 0
    @Binding var refreshList : Bool
    @State private var showAlert = false
    
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
                if FullScreen && selected == 1 {
                    GRMapView(
                        fullScreen: $FullScreen,
                        selectPosion: $selectedCoordinate,
                        annotations: $annotations
                    )
                }else{
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
                                
                            }
                                .padding(.top, 20)
                            
                            SensorButton(title: "Next") {
                                next()
                            }
                            .frame(height: 50)
                            .padding(.top, 15)
                            
                            Spacer()
                            
                        case 1:
                            Text("Please add a marker using icon to locate your sensor on the map.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            GRMapView(
                                fullScreen: $FullScreen,
                                selectPosion: $selectedCoordinate,
                                annotations: $annotations
                            )
                            HStack{
                                GRButton(enable:enableBtn, title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                    undo()
                                })
                                GRButton(enable:enableBtn, title: "Next") {
                                    next()
                                }
                            }
                            .frame(height: 50)
                            .padding(.top, 15)
                            .padding(.bottom, 50)

                        
                        case 2:
                            SensorSubmitView(gateway: sensorID) {
                                guard let selectedCoordinate = selectedCoordinate else {
                                    return
                                }

                                print("Selected Coordinate: \(selectedCoordinate.latitude), \(selectedCoordinate.longitude)")
                                
                                SensorListApi.shared.createSensor(sensorID: sensorID, fieldID: fieldID, coordinate: selectedCoordinate) { result in
                                    switch result {
                                    case .success:
                                        DispatchQueue.main.async {
                                            showAddSensorSheet = false
                                            refreshList = true
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    case .failure(let error):
                                        print("Error creating sensor: \(error)")
                                        showAlert = true
                                    }
                                }
                                
                            }
                                .padding(.top,20)
                                Spacer()
                        
                        default :
                            HStack{}
                        }
                        Spacer()
                        
                    }.padding(.leading,30)
                        .padding(.trailing,30)
                    
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
            .alert(isPresented: $showAlert) { // Added alert presentation
                Alert(
                    title: Text("Create Sensor Failure"),
                    message: Text("Failed to insert the sensor. Please try again later."),
                    dismissButton: .default(Text("OK"))
                )
            }
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
