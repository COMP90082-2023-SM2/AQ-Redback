//
//  SensorEditView.swift
//  AquaTerra
//
//  Created by Davincci on 15/9/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct SensorEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SessionViewViewModel
    let sensorId: String
    let username: String
    let fieldId: String
    
    @State private var sensorDetail: SensorDetail?
    @State private var selectPosion: CLLocationCoordinate2D?
    @State private var editedAlias: String?
    @State var editedLatitude: String?
    @State var editedLongitude: String?
    @State var fieldData: [FieldData]
    @Binding var region : MKCoordinateRegion
    @State private var editedSleeping: String?
    @State private var annotations: [MKPointAnnotation] = []
    @State private var FullScreen = false
    @State private var selected = 0
    @State private var textFiledText : String = ""
    
    
    private var enableBtn : Binding<Bool> {
        Binding<Bool>(
            get: {
                return selectPosion != nil
            },
            set: { _ in}
        )
    }
    
    var body: some View {
            VStack {
                if FullScreen && selected == 1 {
                    SensorMapView(fullScreen: $FullScreen, selectPosion: $selectPosion, annotations: $annotations, latitude: $editedLatitude, longitude: $editedLongitude, region:$region)
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
                }else{
                    FMNavigationBarView(title: "Edit Sensor")
                        .frame(height: 45)
                    SensorStepView(selected: $selected).padding(.vertical, 20)
                    VStack{
                        switch selected {
                        case 0:
                            VStack{
                                if let sensorDetail = sensorDetail {
                                    SensorIDBar(sensorDetail: sensorDetail)
                                    VStack{
                                        EditViewListItem(title: "Alias", detail: Binding(
                                            get: {self.editedAlias ?? ""},set: {self.editedAlias = $0}))
                                        EditViewListItem(title: "Latitude", detail: Binding(
                                            get: {self.editedLatitude ?? ""},set: {self.editedLatitude = $0}))
                                        EditViewListItem(title: "Latitude", detail: Binding(
                                            get: {self.editedLongitude ?? ""},set: {self.editedLongitude = $0}))
                                        EditViewListItem(title: "Sleeping Time (Hr)", detail: Binding(
                                            get: {self.editedSleeping ?? ""},set: {self.editedSleeping = $0}))
                                    }
                                    SensorButton(title: "Next") {
                                        next()
                                    }
                                    .frame(height: 50)
                                    .padding(.top, 15)
                                    .padding(.horizontal,30)
                                } else {
                                    Text("Loading sensor data...")
                                }
                            }
                            Spacer()
                                .onAppear {
                                    // Fetch sensor details when the view appears
                                    viewModel.fetchSensorDetail(sensorId: sensorId, username: username, fieldId: fieldId) { result in
                                        switch result {
                                        case .success(let sensorDetail):
                                            DispatchQueue.main.async {
                                                self.sensorDetail = sensorDetail
                                                parseCoordinates(sensorDetail.points)
                                                editedAlias = sensorDetail.alias ?? ""
                                                editedSleeping = "\(sensorDetail.sleeping ?? 0)"
                                                print("Edit DispatchQueue successful")
                                            }
                                        case .failure(let error):
                                            print("Viewedit: Error fetching sensor details: \(error)")
                                        }
                                    }
                                    print("Async operation completed")
                                }

                        case 1:
                            Text("Please add a marker using icon to locate your sensor on the map.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                            SensorMapView(fullScreen: $FullScreen, selectPosion: $selectPosion, annotations: $annotations, latitude: $editedLatitude, longitude: $editedLongitude, region: $region)
                                .padding(.horizontal, 30)
                            HStack{
                                SensorButton(title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                    undo()
                                    presentationMode.wrappedValue.dismiss()
                                })
                                Spacer().frame(width: 20)
                                SensorButton(title: "Next") {
                                    next()
                                }
                            }
                            .frame(height: 50)
                            .padding(.top, 15)
                            .padding(.bottom, 50)
                            .padding(.horizontal, 30)
                            Spacer()
                        case 2:
                            SensorSubmitView(gateway: sensorId) {
                                submit()
                            }
                            .padding(.horizontal, 30)
                            .padding(.top,20)
                            Spacer()
                        default :
                            HStack{}
                        }
                        Spacer()
                    }.navigationBarTitle("", displayMode: .inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                NavigationBackView()
                                    .onTapGesture {
                                        presentationMode.wrappedValue.dismiss()
                                        BaseBarModel.share.show()
                                    }
                                    .frame(width: 70,height: 17)
                            }
                        }
                }
            }.navigationBarBackButtonHidden(true)
    }
    // Helper method to parse coordinates from JSON string
    private func parseCoordinates(_ points: String?) {
        guard let pointsData = points?.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: pointsData, options: []) as? [String: Any],
              let coordinates = json["coordinates"] as? [Double],
              coordinates.count == 2 else {
            print("Invalid coordinates")
            return
        }
        
        let latitude = String(coordinates[1])
        let longitude = String(coordinates[0])
        
        editedLatitude = latitude
        editedLongitude = longitude
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
    
    private func submit() {
        if var editedSensorDetail = sensorDetail {
            // Update the edited fields
            editedSensorDetail.alias = editedAlias
            if let latitudeStr = editedLatitude, let longitudeStr = editedLongitude,
               let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                editedSensorDetail.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            if let sleepingStr = editedSleeping, let sleeping = Int(sleepingStr) {
                editedSensorDetail.sleeping = sleeping
                
                // Check if selectPosion is not nil
                if let selectedCoordinate = selectPosion {
                    viewModel.editSensor(sensorDetail: editedSensorDetail, coordinate: selectedCoordinate) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        case .failure(let error):
                            print("Error editing sensor: \(error)")
                        }
                    }
                } else {
                    print("no position")
                    // Use the sensor's current coordinate
                    if let sensorCoordinate = editedSensorDetail.coordinate {
                        viewModel.editSensor(sensorDetail: editedSensorDetail, coordinate: sensorCoordinate) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            case .failure(let error):
                                print("Error editing sensor: \(error)")
                            }
                        }
                    } else {
                        print("Error: No coordinate selected or available")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

}
