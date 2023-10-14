//
//  DashboardSensorPicker.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardSensorPicker: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    var body: some View {
        HStack(spacing: 0) {
            Text("You are viewing  ")
                .font(.custom("OpenSans-SemiBold", size: 16))
            Text("\(dashboardViewModel.sensorSelection.sensor_id)")
                .foregroundColor(Color("GreenHightlight"))
                .font(.custom("OpenSans-Bold", size: 16))
            Spacer()
            
            
            NavigationLink {
                SensorPickerView(viewModel: dashboardViewModel)
            } label: {
                Image("arrow-down-s-fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
//            Menu {
//                ForEach(dashboardViewModel.sensors) { it in
//                    Button(it.sensor_id) {
//                        dashboardViewModel.sensorSelection = it
//                    }
//                }
//            } label: {
//                Image("arrow-down-s-fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24)
//            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .background(Color("Hint").opacity(0.7))
    }
}
