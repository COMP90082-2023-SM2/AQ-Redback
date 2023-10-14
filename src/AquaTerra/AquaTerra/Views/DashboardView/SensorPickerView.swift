//
//  SensorPickerView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 14/10/2023.
//

import SwiftUI

struct SensorPickerView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
            VStack(spacing: 0){
                FMNavigationBarView(title: "Select a Sensor")
                    .frame(height: 45)
                Divider()
                
                List {
                    ForEach(viewModel.sensors) { sensor in
                        HStack(spacing: 0){
                            Button(action: {
                                   viewModel.sensorSelection = sensor
                                    presentationMode.wrappedValue.dismiss()
                                }
                            ) {
                                Text(sensor.sensor_id)
                                    .font(.custom("OpenSans-SemiBold", size: 16))
                                    .padding(.leading, 30)
                                
                                
                            }
                            
                        }
                        Divider()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color("bar"))
                        
                            
                    }.frame(height: 30)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .padding(.top, 20)
                .listRowInsets(EdgeInsets())

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
                .onAppear {
                    BaseBarModel.share.hidden()
                    
                }
        }
}



