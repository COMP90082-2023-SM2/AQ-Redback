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
        
            VStack(spacing: 0){
                FMNavigationBarView(title: "Select a Field")
                    .frame(height: 45)
                Divider()
                
                List {
                    ForEach(fieldData, id: \.field_id) { sensor in
                        HStack(spacing: 0){
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
                                    .padding(.leading, 30)
                                
                                
                            }
                            
                        }
                        Divider()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color("bar"))
                        
                            
                    }.frame(height: 40)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .padding(.top, 20)

            }
//            .navigationBarTitle("", displayMode: .inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        NavigationBackView()
//                            .onTapGesture {
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                            .frame(width: 70,height: 17)
//                    }
//                }
//                .navigationBarBackButtonHidden(true)
        }
       
    }

//struct SelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionView()
//    }
//}
