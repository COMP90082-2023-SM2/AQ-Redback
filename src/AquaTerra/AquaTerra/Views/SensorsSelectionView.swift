//
//  SensorsSelectionView.swift
//  AquaTerra
//
//  Created by Davincci on 11/10/2023.
//

import SwiftUI

struct SensorsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showV1 = false
    @State private var showV2 = false
    @ObservedObject var viewModel: SessionViewViewModel
    @State var sensorData: [SensorData] = []
    @Binding var fieldData: [FieldData]
    @Binding var showAddSensorSheet: Bool
    var fieldID: String
    @Binding var refreshList : Bool
    
    var body: some View {
        VStack{
            FMNavigationBarView(title: "Select Sensor Version")
                .frame(height: 45)
            Divider()
            
            Text("Please Select A Type Of Sensor To Proceed")
                .font(.custom("OpenSans-Regular", size: 16))
                .frame(alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            HStack{
                Button(action: {
                    // Show the add sensor sheet
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color("ButtonGradient1"))
                            .frame(height: 50)
                            .frame(width: 170)
                        
                        Text("Add New Sensor V1")
                            .foregroundColor(Color.white)
                            .font(.custom("OpenSans-Bold", size: 16))
                            
                    }
                }
                //        NavigationLink("",destination: AddSensorView(viewModel: viewModel, showAddSensorSheet: $showAddSensorSheet, fieldID: selectedFieldName?.field_id ?? "", fieldData: fieldData, refreshList: $refreshList),isActive: $showAddSensorSheet).opacity(0)
                
                Spacer()
                
                Button(action: {
                    showV2 = true
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color("ButtonGradient2"))
                            .frame(height: 50)
                            .frame(width: 170)
                        
                        Text("Add New Sensor V2")
                            .foregroundColor(Color.white)
                            .font(.custom("OpenSans-Bold", size: 16))
                    }
                }
                NavigationLink("",destination: AddSensorView(viewModel: viewModel, showAddSensorSheet: $showAddSensorSheet, fieldID: fieldID, fieldData: fieldData, refreshList: $refreshList), isActive: $showV2).opacity(0)
                
            }.padding(.horizontal, 30)
            
            Spacer()
    
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

//#Preview {
//    SensorsSelectionView()
//}
