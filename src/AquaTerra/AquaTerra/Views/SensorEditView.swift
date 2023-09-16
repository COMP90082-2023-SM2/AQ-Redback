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
    @State private var editedLatitude: String?
    @State private var editedLongitude: String?

    @State private var editedSleeping: String?
    @State private var annotations: [MKPointAnnotation] = []
    @State private var FullScreen = true
    @State private var seletected = 0
    
    var body: some View {
        
        NavigationStack{
            
            VStack {
                FMNavigationBarView(title: "Edit Sensor")
                    .frame(height: 45)
                
                SensorStepView(selected: $seletected)
                    .padding(.vertical, 20)

                if let sensorDetail = sensorDetail {
                    SensorIDBar(sensorDetail: sensorDetail)
                    VStack{
                       EditViewListItem(title: "Alias", detail: Binding(
                            get: {self.editedAlias ?? ""},set: {self.editedAlias = $0}))
                       EditViewListItem(title: "Latitude", detail: Binding.constant(parseCoordinates(sensorDetail.points)[0] ?? ""))
                       EditViewListItem(title: "Longitude", detail: Binding.constant(parseCoordinates(sensorDetail.points)[1] ?? ""))
                        EditViewListItem(title: "Sleeping Time (Hr)", detail: Binding(
                            get: {self.editedSleeping ?? ""},set: {self.editedSleeping = $0}))
                    }
                } else {
                    Text("Loading sensor data...")
                }
                
                
//                GRMapView(
//                    fullScreen: $FullScreen,
//                    selectPosion: $selectPosion,
//                    annotations: $annotations
//                )
//                .frame(height: FullScreen ? 200 : 550)
                
                Button(action: {
                    // Save the edited sensor information here
                    if var editedSensorDetail = sensorDetail {
                        // Update the edited fields
                        editedSensorDetail.alias = editedAlias
                        if let latitudeStr = editedLatitude, let longitudeStr = editedLongitude,
                                                   let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                                                    editedSensorDetail.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                                }
                        
                        // Check if selectPosion is not nil before updating
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
                            print("Error: No coordinate selected")
                            
                        }
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .onAppear {
                // Fetch sensor details when the view appears
                print("View appeared (before async operation)")
                viewModel.fetchSensorDetail(sensorId: sensorId, username: username, fieldId: fieldId) { result in
                    switch result {
                    case .success(let sensorDetail):
                        DispatchQueue.main.async {
                            self.sensorDetail = sensorDetail
                            editedAlias = sensorDetail.alias ?? ""
                            editedLatitude = "\(sensorDetail.coordinate?.latitude ?? 0)"
                            editedLongitude = "\(sensorDetail.coordinate?.longitude ?? 0)"
                            editedSleeping = "\(sensorDetail.sleeping ?? 0)"
                            print("Edit DispatchQueue successful")
                        }
                    case .failure(let error):
                        print("Viewedit: Error fetching sensor details: \(error)")
                    }
                }
                print("Async operation completed")
            }.navigationBarTitle("", displayMode: .inline)
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
            
        }
  
    
    // Helper method to parse coordinates from JSON string
    private func parseCoordinates(_ points: String?) -> [String] {
        guard let pointsData = points?.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: pointsData, options: []) as? [String: Any],
              let coordinates = json["coordinates"] as? [Double],
              coordinates.count == 2 else {
            return ["Invalid coordinates"]
        }
        
        let latitude = String(coordinates[1])
        let longitude = String(coordinates[0])
        
        return [latitude, longitude]
    }

}
