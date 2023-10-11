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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.840935, longitude: 144.946457), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var polygenResults: String? = ""
    
    @State var editedLatitude: String?
    @State var editedLongitude: String?
    
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
                            ScrollView(showsIndicators: false){
                                VStack(spacing: 10){
                                    Text("• Press and hold the physical sensor button until it flashes, one sensor at a time.")
                                        .font(.custom("OpenSans-Regular", size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("• Wait about 60 seconds and the sensor will flash twice after the sensor has successfully paired with the gateway.")
                                        .font(.custom("OpenSans-Regular", size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("• If pairing is unsuccessful, the sensor will flash rapidly, in that case, retry step 1 or contact AquaTerra support.")
                                        .font(.custom("OpenSans-Regular", size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image("SensorPairing")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                
                                SensorButton(title: "Next") {
                                    fetchGatewaySensors()
                                    print("fieldid: ", fieldID)
    //                                fetchFieldZone(fieldId: fieldID)
                                    
                                    SensorListApi.shared.getFieldZone(userName: "demo") { result in
                                        switch result {
                                        case .success(let fieldData):
                                            if let specificField = fieldData.first(where: { $0.field_id == fieldID }) {
                                                let points = specificField.points
                                                let jsonData = specificField.points.data(using: .utf8)

                                                do {
                                                    if let jsonData = jsonData,
                                                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                                        let coordinates = json["coordinates"] as? [[[Double]]] {
                                                        
                                                        // Flatten the array of coordinates
                                                        let flattenedCoordinates = coordinates.flatMap { $0 }
                                                        
                                                        // Convert the flattened coordinates to a string
                                                        let coordinateStrings = flattenedCoordinates.map { "[\($0[0]), \($0[1])]" }
                                                        
                                                        // Join the coordinate strings with commas
                                                        polygenResults = coordinateStrings.joined(separator: ",")
                                                        
                                                        print("Extracted coordinates: [\(polygenResults)]")
                                                    }
                                                } catch {
                                                    print("Error parsing JSON: \(error)")
                                                }
                                                
                                            }
                                        case .failure(let error):
                                            print("No points")
                                        }
                                    }
                                    
                                }
                                .frame(height: 50)
                                .padding(.top, 15)
                            }.padding(.bottom, 50)



                        case 2:
                            VStack{
                                if let response = gatewaySensorResponse {
                                    switch response {
                                    case .success(let gatewaySensorResponse):
                                        if !gatewaySensorResponse.data.isEmpty {
                                            // Show sensors
                                            ForEach(gatewaySensorResponse.data, id: \.sensor_id) { sensor in
                                                Text("Sensor ID: \(sensor.sensor_id), Gateway ID: \(sensor.gateway_id)")
                                                    .font(.custom("OpenSans-Regular", size: 14))
                                                    .foregroundColor(Color("Placeholder"))
                                                    .frame(height: 50)
                                                    .frame(maxWidth: .infinity)
                                                    .accentColor(Color("ButtonGradient2"))
                                                    .background(Color("Hint"))
                                                    .cornerRadius(5)
                                                    .padding(.bottom, 10)
                                            }
                                            Text("Please place a marker using the icon to locate your sensor on the map.")
                                                .font(.custom("OpenSans-Regular", size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            SensorMapViewVOne(fullScreen: $FullScreen, selectPosion: $selectedCoordinate, annotations: $annotations, latitude: $editedLatitude, longitude: $editedLongitude, region: $region, polygenResults: $polygenResults)
                                                .padding(.bottom, 15)
                                            
                                        
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
                                    submitSensorV1(sensorId: sensorID, gatewayId: gatewayIDs[0], fieldId: fieldID, coordinate: selectedCoordinate!)
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .frame(height: 50)
                                .padding(.bottom, 50)
                                .disabled(selectedCoordinate == nil)
                                .opacity(selectedCoordinate == nil ? 0.3 : 1.0)
                                
                            }.frame(height: 550)
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
                switch result {
                case .success(let gatewaySensorResponse):
                    self.gatewaySensorResponse = result
                    if !gatewaySensorResponse.data.isEmpty {
                        if let sensor = gatewaySensorResponse.data.first {
                            self.sensorID = sensor.sensor_id
                        }
                        next()
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
        }
    }

    
    private func fetchFieldZone(fieldId: String) {
        SensorListApi.shared.getFieldZone(userName: "demo") { result in
            switch result {
            case .success(let fieldData):
                if let specificField = fieldData.first(where: { $0.field_id == fieldId }) {
                    let points = specificField.points
                    print("Points for Field \(fieldId): \(points)")
                }
            case .failure(let error):
                print("No points")
            }
        }
    }
    
    private func submitSensorV1(sensorId: String, gatewayId: String, fieldId: String, coordinate: CLLocationCoordinate2D) {
        SensorListApi.shared.submitSensorV1(sensorId: sensorId, gatewayId: gatewayId, fieldId: fieldId, coordinate: selectedCoordinate!) { result in
            switch result {
            case .success:
                print("Sensor submitted successfully")
            case .failure(let error):
                print("Error submitting sensor: \(error)")
            }
        }
    }

}
