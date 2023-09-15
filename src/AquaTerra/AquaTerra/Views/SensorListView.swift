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
    @State private var sensorData: [SensorData] = []

    @State private var showAlert = false
    @State private var deletionIndex: Int?
    @State private var showAddSensorSheet = false
    @State private var shouldRefreshData = false

    @State private var selectedSensor: SensorData?

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

                Group {
                    if selectedFieldName != nil {
                        Button(action: {
                            // Show the add sensor sheet
                            showAddSensorSheet = true
                        }) {
                            Label("Add Sensor", systemImage: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }

                List {
                    ForEach(sensorData) { sensor in
                        HStack {
                            Text("Sensor ID: \(viewModel.abbreviateSensorID(sensor.sensor_id))")
                                .font(.title)
                            Spacer()
                            Text("Gateway ID: \(sensor.gateway_id ?? "")")
                                .font(.title)

                            NavigationLink(
                                destination: SensorEditView(
                                    viewModel: viewModel,
                                    sensorId: sensor.sensor_id,
                                    username: sensor.username ?? "",
                                    fieldId: sensor.field_id
                                ),
                                label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title)
                                }
                            )

                            Button(action: {
                                deletionIndex = sensorData.firstIndex(of: sensor)
                                showAlert = true
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                    }
                    .onDelete(perform: deleteSensor)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Delete Sensor"),
                        message: Text("Are you sure you want to delete this sensor?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = deletionIndex {
                                let sensorToDelete = sensorData[index]
                                viewModel.deleteSensor(sensorID: sensorToDelete.sensor_id) { result in
                                    switch result {
                                    case .success:
                                        sensorData.remove(at: index)
                                    case .failure(let error):
                                        print("Error deleting sensor: \(error)")
                                    }
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
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
        .sheet(isPresented: $showAddSensorSheet) {
            if let field = selectedFieldName {
                AddSensorView(viewModel: viewModel, showAddSensorSheet: $showAddSensorSheet, fieldID: field.field_id)
            }
        }
    }

    private func deleteSensor(at offsets: IndexSet) {
        if let firstIndex = offsets.first {
            deletionIndex = firstIndex
            showAlert = true
        }
    }
}

struct SensorListView_Previews: PreviewProvider {
    static var previews: some View {
        SensorListView(fieldData: [], viewModel: SessionViewViewModel())
    }
}
