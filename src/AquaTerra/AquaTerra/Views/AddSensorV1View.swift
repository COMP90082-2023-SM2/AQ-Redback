//
//  AddSensorV1View.swift
//  AquaTerra
//
//  Created by Davincci on 11/10/2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddSensorV1View: View {
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

    @Binding var gatewayIDs: [String]
    
    @State private var gatewaySensorResponse: Result<GatewaySensorResponse, Error>? = nil
    
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
                                if !gatewayIDs.isEmpty {
                                    ForEach(gatewayIDs, id: \.self) { gatewayID in
                                        Text("Gateway ID: \(gatewayID)")
                                            .font(.custom("OpenSans-Regular", size: 14))
                                            .foregroundColor(Color("Placeholder"))
                                            .padding([.horizontal], 15)
                                            .frame(height: 50)
                                            .accentColor(Color("ButtonGradient2"))
                                            .background(Color("Hint"))
                                            .cornerRadius(5)
                                    }
                                    
                                    SensorButton(title: "Next") {
                                        setupGatewayAPI()
                                    }
                                    .frame(height: 50)
                                    .padding(.top, 15)
                                } else {
                                    // Handle the case when gatewayIDs is empty
                                }
                                
                            }
                            .padding(.top, 20)
                            Spacer()
                            
                        case 1:
                            Text("Please add a marker using icon to locate your sensor on the map.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            SensorButton(title: "Next") {
                                fetchGatewaySensors()
                            }
                            .frame(height: 50)
                            .padding(.top, 15)

                        case 2:
                            if let response = gatewaySensorResponse {
                                switch response {
                                case .success(let gatewaySensorResponse):
                                    if !gatewaySensorResponse.data.isEmpty {
                                        // Show sensors
                                        ForEach(gatewaySensorResponse.data, id: \.sensor_id) { sensor in
                                            Text("Sensor ID: \(sensor.sensor_id), Gateway ID: \(sensor.gateway_id)")
                                                .font(.custom("OpenSans-Regular", size: 14))
                                                .foregroundColor(Color("Placeholder"))
                                                .padding([.horizontal], 15)
                                                .frame(height: 50)
                                                .accentColor(Color("ButtonGradient2"))
                                                .background(Color("Hint"))
                                                .cornerRadius(5)
                                        }
                                    } else {
                                        // Handle case when no sensors are found
                                        Text("No Sensor Found")
                                            .font(.custom("OpenSans-Regular", size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                case .failure(let error):
                                    // Handle the failure
                                    Text("Error: \(error.localizedDescription)")
                                        .font(.custom("OpenSans-Regular", size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            SensorButton(title: "Submit") {
                                next()
                            }
                            .frame(height: 50)
                            .padding(.top, 15)

                        
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
    
    private func setupGatewayAPI() {
        SensorListApi.shared.checkGatewayAPI(gatewayIds: gatewayIDs) { result in
            switch result {
            case .success(let response):
                if response.data == "ok" {
                    next()
                }
            case .failure(let error):
                print("Error setting up gateway: \(error)")
            }
        }
    }
    
    private func fetchGatewaySensors() {
        SensorListApi.shared.fetchGatewaySensors(gatewayIds: gatewayIDs) { result in
            DispatchQueue.main.async {
                self.gatewaySensorResponse = result
                next()
            }
        }
    }

}
