//
//  SensorListView.swift
//  AquaTerra
//
//  Created by Davincci on 9/9/2023.
//

import SwiftUI

struct SensorListView: View {
    var sensorData: [FieldData]

    @ObservedObject var viewModel: SessionViewViewModel
    @State private var selectedFieldName: FieldData?
    @State private var fieldID: String? = nil
    @State private var gatewayID: String? = nil
    @State private var isMenuVisible = false

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

                Text("Field ID: \(fieldID ?? "")")
                    .font(.title)
                    .padding()

                Text("Gateway ID: \(gatewayID ?? "")")
                    .font(.title)
                    .padding()

                HStack {
                    Spacer()
                    Menu("Select a Field") {
                        ForEach(sensorData, id: \.field_id) { sensor in
                            Button(action: {
                                selectedFieldName = sensor
                                isMenuVisible = false

                                viewModel.fetchSensorData(fieldId: sensor.field_id) { result in
                                    switch result {
                                    case .success(let sensorDataResponse):
                                        if let firstSensor = sensorDataResponse.data.first {
                                            self.fieldID = firstSensor.field_id
                                            self.gatewayID = firstSensor.gateway_id
                                        }
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
                    .padding()
                    .font(.title)
                }

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
