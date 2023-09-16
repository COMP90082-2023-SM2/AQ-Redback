//
//  SensorListItem.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 16/9/2023.
//

import SwiftUI



struct SensorListItem: View {
    @State var sensorID : String
    @State var gatewayID : String
    @Binding var deletionIndex: Int?
    @State private var showAlert = false
    @Binding var sensorData: [SensorData]
    @State var sensor: SensorData
    @ObservedObject var viewModel: SessionViewViewModel
    
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

                Button(action: {
                    
                }) {
                    Image("edit").resizable()
                        .frame(width: 38,height: 38)
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
                .frame(height: 2)
            
        }
            .frame(height: 68)
            .listRowInsets(EdgeInsets())
            .onTapGesture {return}

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
