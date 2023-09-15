//
//  SensorEditView.swift
//  AquaTerra
//
//  Created by Davincci on 15/9/2023.
//

//import SwiftUI
//import CoreLocation
//import MapKit
//
//struct SensorEditView: View {
//    @Environment(\.presentationMode) var presentationMode
//    
//    @ObservedObject var viewModel: SessionViewViewModel
//    let sensorId: String
//    let username: String
//    let fieldId: String
//    
//    @State private var sensorDetail: SensorDetail? // Use @State to manage sensorDetail
//    @State private var selectPosion: CLLocationCoordinate2D? // Store the selected coordinate
//    
//    var body: some View {
//        VStack {
//            Text("Edit Sensor")
//                .font(.largeTitle)
//                .bold()
//                .padding()
//            
//            if let sensorDetail = sensorDetail {
//                Text("Sensor ID: \(sensorDetail.sensor_id)")
//                    .font(.title)
//                Text("Alias: \(sensorDetail.alias ?? "")")
//                    .font(.title)
//                Text("Coordinates: \(parseCoordinates(sensorDetail.points))")
//                    .font(.title)
//                Text("Sleeping: \(sensorDetail.sleeping ?? 0)")
//                    .font(.title)
//            } else {
//                Text("Loading sensor data...")
//            }
//            
//            // GRMapView for selecting coordinates
//            GRMapView(fullScreen: .constant(false), selectPosion: $selectPosion, annotations: .constant([]))
//            
//            Button(action: {
//                // Save the edited sensor information here
//                if let editedSensorDetail = sensorDetail {
//                    // Send editedSensorDetail to the backend
//                    
//                    if let selectedCoordinate = selectPosion {
//                        // Update the @Binding property to modify the sensorDetail in the view model
//                        viewModel.sensorDetail?.coordinate = selectedCoordinate
//                    }
//                    
//                    // Dismiss the view
//                    presentationMode.wrappedValue.dismiss()
//                }
//
//            }) {
//                Text("Save")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(width: 200, height: 50)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding()
//            }
//        }
//        .onAppear {
//            // Fetch sensor details when the view appears
//            print("View appeared (before async operation)")
//            viewModel.fetchSensorDetail(sensorId: sensorId, username: username, fieldId: fieldId) { result in
//                switch result {
//                case .success(let sensorDetail):
//                    DispatchQueue.main.async {
//                        self.sensorDetail = sensorDetail // Update the @State property
//                        print("Edit DispatchQueue successful")
//                    }
//                case .failure(let error):
//                    print("Viewedit: Error fetching sensor details: \(error)")
//                }
//            }
//            print("Async operation completed")
//        }
//    }
//    
//    // Helper method to parse coordinates from JSON string
//    private func parseCoordinates(_ points: String?) -> String {
//        guard let pointsData = points?.data(using: .utf8),
//              let json = try? JSONSerialization.jsonObject(with: pointsData, options: []) as? [String: Any],
//              let coordinates = json["coordinates"] as? [Double],
//              coordinates.count == 2 else {
//            return "Invalid coordinates"
//        }
//        
//        let latitude = coordinates[1]
//        let longitude = coordinates[0]
//        
//        return "Latitude: \(latitude), Longitude: \(longitude)"
//    }
//}

import SwiftUI
import CoreLocation
import MapKit

struct SensorEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SessionViewViewModel
    let sensorId: String
    let username: String
    let fieldId: String
    
    @State private var sensorDetail: SensorDetail? // Use @State to manage sensorDetail
    @State private var selectPosion: CLLocationCoordinate2D? // Store the selected coordinate
    @State private var editedAlias: String = ""
    @State private var editedLatitude: String = ""
    @State private var editedLongitude: String = ""
    @State private var editedSleeping: String = ""
    
    var body: some View {
        VStack {
            Text("Edit Sensor")
                .font(.largeTitle)
                .bold()
                .padding()
            
            if let sensorDetail = sensorDetail {
                Text("Sensor ID: \(sensorDetail.sensor_id)")
                    .font(.title)
                
                TextField("Alias", text: $editedAlias)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Coordinates: \(parseCoordinates(sensorDetail.points))")
                    .font(.title)
                
                HStack {
                    TextField("Latitude", text: $editedLatitude)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Longitude", text: $editedLongitude)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                TextField("Sleeping", text: $editedSleeping)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                Text("Loading sensor data...")
            }
            
            // GRMapView for selecting coordinates
            GRMapView(fullScreen: .constant(false), selectPosion: $selectPosion, annotations: .constant([]))
            
            Button(action: {
                // Save the edited sensor information here
                if var editedSensorDetail = sensorDetail {
                    // Update the edited fields
                    editedSensorDetail.alias = editedAlias
                    if let latitude = Double(editedLatitude), let longitude = Double(editedLongitude) {
                        editedSensorDetail.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }
                    editedSensorDetail.sleeping = Int(editedSleeping)
                    
                    // Check if selectPosion is not nil before updating
                    if let selectedCoordinate = selectPosion {
                        viewModel.editSensor(sensorDetail: editedSensorDetail, coordinate: selectedCoordinate) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    // Dismiss the view on successful save
                                    presentationMode.wrappedValue.dismiss()
                                }
                            case .failure(let error):
                                print("Error editing sensor: \(error)")
                                // Handle the error as needed
                            }
                        }
                    } else {
                        // Handle the case where selectPosion is nil
                        print("Error: No coordinate selected")
                        // You can display an error message or take appropriate action here
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
                        self.sensorDetail = sensorDetail // Update the @State property
                        // Initialize the edited fields with the current values
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
        }
    }
    
    // Helper method to parse coordinates from JSON string
    private func parseCoordinates(_ points: String?) -> String {
        guard let pointsData = points?.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: pointsData, options: []) as? [String: Any],
              let coordinates = json["coordinates"] as? [Double],
              coordinates.count == 2 else {
            return "Invalid coordinates"
        }
        
        let latitude = coordinates[1]
        let longitude = coordinates[0]
        
        return "Latitude: \(latitude), Longitude: \(longitude)"
    }
}
