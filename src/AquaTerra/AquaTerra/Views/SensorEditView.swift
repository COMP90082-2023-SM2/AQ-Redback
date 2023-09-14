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
    @ObservedObject var viewModel: SessionViewViewModel
    @Binding var isPresented: Bool
    let sensorData: SensorData
    @State private var alias: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var sleepingTime: String = ""

    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [MKPointAnnotation] = []
    @State private var isMapViewPresented = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sensor Information")) {
                    TextField("Alias", text: $alias)
                    TextField("Latitude", text: $latitude)
                    TextField("Longitude", text: $longitude)
                    TextField("Sleeping Time", text: $sleepingTime)
                }

                Section {
                    Button("Show Map") {
                        isMapViewPresented.toggle()
                    }
                    Button("Save") {
                        // 检查是否有有效的坐标
                        guard let coordinate = selectedCoordinate else {
                            print("No coordinate selected!")
                            return
                        }

                        // 将坐标转换为字符串
                        let latitudeString = String(coordinate.latitude)
                        let longitudeString = String(coordinate.longitude)

                        let editedSensorData = SensorData(
                            sensor_id: sensorData.sensor_id,
                            gateway_id: sensorData.gateway_id,
                            field_id: sensorData.field_id,
                            geom: "POINT(\(longitudeString) \(latitudeString))",
                            datetime: sensorData.datetime,
                            is_active: sensorData.is_active,
                            has_notified: sensorData.has_notified,
                            username: sensorData.username,
                            sleeping: Int(sleepingTime),
                            alias: alias.isEmpty ? nil : alias,
                            points: nil,
                            field_name: sensorData.field_name
                        )
                        viewModel.editSensor(sensorData: editedSensorData, coordinate: coordinate) {
                            isPresented = false
                            print("Save button tapped!")
                        }
                    }


                }
            }
            .navigationBarTitle("Edit Sensor", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
            .sheet(isPresented: $isMapViewPresented) {
                GRMapView(
                    fullScreen: $isMapViewPresented,
                    selectPosion: $selectedCoordinate,
                    annotations: $annotations
                )
                .onDisappear {
                    // 当地图视图关闭时，更新相关的数据
                    updateData()
                }
            }
        }
    }

    func updateData() {
        if let coordinate = selectedCoordinate {
            latitude = "\(coordinate.latitude)"
            longitude = "\(coordinate.longitude)"
        }
    }
}
