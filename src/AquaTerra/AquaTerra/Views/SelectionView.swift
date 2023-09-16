//
//  SelectionView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 15/9/2023.
//

import SwiftUI

struct SelectionView: View {
    @Binding var selectedFieldName: FieldData?
    @ObservedObject var viewModel: SessionViewViewModel
    @Binding var fieldData: [FieldData]
    @Binding var sensorData: [SensorData]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        NavigationStack{
            VStack{
                FMNavigationBarView(title: "Select a Field")
                    .frame(height: 45)
                Divider()
                
                List {
                    ForEach(fieldData, id: \.field_id) { sensor in
                        HStack{
                            Button(action: {
                                selectedFieldName = sensor
                                viewModel.fetchSensorData(fieldId: sensor.field_id) { result in
                                    switch result {
                                    case .success(let sensorDataResponse):
                                           DispatchQueue.main.async { // Ensure UI updates are on the main thread
                                               self.sensorData = sensorDataResponse.data
                                               self.selectedFieldName = sensor
                                               presentationMode.wrappedValue.dismiss()
                                           }

                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                    
                                }
                            }) {
                                Text(sensor.field_name)
                                    .font(.custom("OpenSans-SemiBold", size: 16))
                                
                                
                            }
                        }.frame(height: 68)
                            .listRowInsets(EdgeInsets())
                            
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(.top, -7)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .padding(.bottom, 100)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(.all)

            }
            .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationBackView()
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .frame(width: 70,height: 17)
                    }
                }
                .navigationBarBackButtonHidden(true)
        }
       
    }
}

//struct SelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionView()
//    }
//}
