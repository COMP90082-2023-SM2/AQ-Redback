//
//  SensorListView.swift
//  AquaTerra
//
//  Created by Davincci on 9/9/2023.
//

import SwiftUI

struct SensorListView: View {
    var fieldData: [FieldData]

    @ObservedObject var viewModel: SessionViewViewModel
    @State private var selectedFieldName: FieldData?
    @State private var sensorData: [SensorData] = [] // 存储传感器数据

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("My Sensors")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.leading, 16)
                        .padding(.top, -50)

                    Spacer()
                }

                // Display Sensor ID and Gateway ID
                List(sensorData, id: \.sensor_id) { sensor in
                    HStack {
                        Text("Sensor ID: \(sensor.sensor_id)")
                            .font(.title)
                        Spacer()
                        Text("Gateway ID: \(sensor.gateway_id ?? "")")
                            .font(.title)
                    }
                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Select a Field") {
                        ForEach(fieldData, id: \.field_id) { sensor in
                            Button(action: {
                                selectedFieldName = sensor
                                viewModel.fetchSensorData(fieldId: sensor.field_id) { result in
                                    switch result {
                                    case .success(let sensorDataResponse):
                                        // 更新传感器数据
                                        self.sensorData = sensorDataResponse.data
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                            }) {
                                Text(sensor.field_name)
                            }
                        }
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                }
            }
        }
    }
}
