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
    let fieldID: String

    @State private var sensorID: String = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var annotations: [MKPointAnnotation] = []
    @State private var FullScreen = true

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sensor Information")) {
                    TextField("Sensor ID", text: $sensorID)
                }

                Section {
                    GRMapView(
                        fullScreen: $FullScreen,
                        selectPosion: $selectedCoordinate,
                        annotations: $annotations
                    )
                    .frame(height: FullScreen ? 200 : 550)
                }

                Button("Add Sensor") {
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
                }

            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Add Sensor", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                showAddSensorSheet = false
            })
        }
    }
}
