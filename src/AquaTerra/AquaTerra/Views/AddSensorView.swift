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

    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sensor Information")) {
                    TextField("Sensor ID", text: $sensorID)
                }

                Section {
                    Map(
                        coordinateRegion: $region,
                        showsUserLocation: true
                    )
                    .frame(height: 200)
                    .gesture(
                        TapGesture().onEnded { gesture in
                            let coordinate = region.center
                            selectedCoordinate = coordinate
                        }
                    )
                }

                Section {
                    Button("Add Sensor") {
                        print("Add Sensor button tapped") 
                        guard let selectedCoordinate = selectedCoordinate else {
                            return
                        }

                        viewModel.addSensor(sensorID: sensorID, fieldID: fieldID, coordinate: selectedCoordinate)

                        showAddSensorSheet = false
                    }
                }
            }
            .listStyle(GroupedListStyle()) // 使用 GroupedListStyle，使列表看起来更接近表单的样式
            .navigationBarTitle("Add Sensor", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                showAddSensorSheet = false
            })
        }
    }
}

