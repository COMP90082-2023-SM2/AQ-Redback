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
    
    @State private var sensorDetail: SensorDetail? // Use @State to manage sensorDetail
    
    var body: some View {
        VStack {
            Text("Edit Sensor")
                .font(.largeTitle)
                .bold()
                .padding()
            
            if let sensorDetail = sensorDetail {
                Text("Sensor ID: \(sensorDetail.sensor_id)")
                    .font(.title)
                Text("Alias: \(sensorDetail.alias ?? "")")
                    .font(.title)
                Text("Coordinates: \(parseCoordinates(sensorDetail.points))")
                    .font(.title)
                Text("Sleeping: \(sensorDetail.sleeping ?? 0)")
                    .font(.title)
            } else {
                Text("Loading sensor data...")
            }
            
            Button(action: {
                // Save the edited sensor information here
                // You can use viewModel or other methods to update the sensor data
                
                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
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
