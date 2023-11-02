//
//  SensorListItem.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 16/9/2023.
//

import SwiftUI
import MapKit
// This is sensor list item view
struct SensorListItem: View {
    @State var sensorID : String
    @State var gatewayID : String
    @Binding var deletionIndex: Int?
    @State private var showAlert = false
    @State private var showEdit = false
    @Binding var sensorData: [SensorData]
    @State var sensor: SensorData
    @ObservedObject var viewModel: SessionViewViewModel
    @State var fieldData: [FieldData]
    @Binding var editedLatitude: String?
    @Binding var editedLongitude: String?
    @State private var region: MKCoordinateRegion

    init(sensorID: String, gatewayID: String, deletionIndex: Binding<Int?>, sensorData: Binding<[SensorData]>, sensor: SensorData, viewModel: SessionViewViewModel, fieldData: [FieldData], editedLatitude: Binding<String?>, editedLongitude: Binding<String?>) {
        self._sensorID = State(initialValue: sensorID)
        self._gatewayID = State(initialValue: gatewayID)
        self._deletionIndex = deletionIndex
        self._sensorData = sensorData
        self._sensor = State(initialValue: sensor)
        self.viewModel = viewModel
        self._fieldData = State(initialValue: fieldData)
        self._editedLatitude = editedLatitude
        self._editedLongitude = editedLongitude

        // Safely unwrap and convert editedLatitude and editedLongitude
        if let latitudeStr = editedLatitude.wrappedValue, let longitudeStr = editedLongitude.wrappedValue,
           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
            self._region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        } else {
            // Provide default values if coordinates are not valid
            self._region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        }
    }

    var body: some View {
        
        VStack{
            HStack {
                Text(sensorID)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .padding(.leading, 20)

                Spacer().frame(width: 23)
                
                Text(gatewayID)
                    .font(.custom("OpenSans-Regular", size: 14))
                
                Spacer()
                Spacer()
                
                
                HStack{
                    Button(action: {
                        showEdit = true
                    }) {
                        Image("edit")
                            .resizable()
                            .frame(width: 38, height: 38)
                    }
                    .background(
                        NavigationLink("", destination: SensorEditView(
                            viewModel: viewModel,
                            sensorId: sensor.sensor_id,
                            username: sensor.username ?? "",
                            fieldId: sensor.field_id,
                            fieldData: fieldData,
                            region: $region
                        ), isActive: $showEdit)
                        .opacity(0)
                    )
                }

                
                Spacer().frame(width: 0)
         
                Button(
                    action: {
                        deletionIndex = sensorData.firstIndex(of: sensor)
                        showAlert = true
                    print("Hello")

                }) {
                    Image("close-circle-fill").resizable()
                        .frame(width: 38,height: 38)
                }.alert(isPresented: $showAlert) {
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
                
            }.padding(.trailing, 20)
            
            Divider()
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("bar"))
            
        }
            .frame(height: 68)
            .listRowInsets(EdgeInsets())
            .onTapGesture {return}
            .listRowBackground(Color.clear)

    }
    private func deleteSensor(at offsets: IndexSet) {
        if let firstIndex = offsets.first {
            deletionIndex = firstIndex
            showAlert = true
        }
    }
}

//struct SensorListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        SensorListItem()
//    }
//}
