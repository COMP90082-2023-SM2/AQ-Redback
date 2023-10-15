//
//  DashboardDateTimePicker.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardDateTimePicker: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if dashboardViewModel.sensorDataTypeSelection == .moisture {
                    switch dashboardViewModel.moistureDepthSelection {
                    case .depth50:
                        Text("Soil Moisture - 50cm")
                            .font(.custom("OpenSans-Regular", size: 7))
                    case .depth100:
                        Text("Soil Moisture - 100cm")
                            .font(.custom("OpenSans-Regular", size: 7))
                    case .depth150:
                        Text("Soil Moisture - 150cm")
                            .font(.custom("OpenSans-Regular", size: 7))
                    }
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("SoilMoisture1"))
                        Rectangle()
                            .fill(Color("SoilMoisture2"))
                        Rectangle()
                            .fill(Color("SoilMoisture3"))
                        Rectangle()
                            .fill(Color("SoilMoisture4"))
                        Rectangle()
                            .fill(Color("SoilMoisture5"))
                    }
                    .frame(height: 15)
                } else if dashboardViewModel.sensorDataTypeSelection == .battery {
                    Text("Battery Voltage")
                        .font(.custom("OpenSans-Regular", size: 7))
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("BatteryVoltage1"))
                        Rectangle()
                            .fill(Color("BatteryVoltage2"))
                        Rectangle()
                            .fill(Color("BatteryVoltage3"))
                        Rectangle()
                            .fill(Color("BatteryVoltage4"))
                        Rectangle()
                            .fill(Color("BatteryVoltage5"))
                    }
                    .frame(height: 15)
                } else if dashboardViewModel.sensorDataTypeSelection == .temperature {
                    Text("Battery Voltage")
                        .font(.custom("OpenSans-Regular", size: 7))
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color("SoilTemperatureColor1"))
                        Rectangle()
                            .fill(Color("SoilTemperatureColor2"))
                        Rectangle()
                            .fill(Color("SoilTemperatureColor3"))
                        Rectangle()
                            .fill(Color("SoilTemperatureColor4"))
                        Rectangle()
                            .fill(Color("SoilTemperatureColor5"))
                    }
                    .frame(height: 15)
                }
                HStack {
                    Text("Low")
                    Spacer()
                    Text("High")
                }
                .font(.custom("OpenSans-Regular", size: 7))
            }
            .frame(width: 130)
            Spacer()
            HStack{
                Text("Time")
                    .font(.custom("OpenSans-Bold", size: 13))
                    .foregroundColor(Color("HighlightColor"))
                Slider(value: $dashboardViewModel.addDays, in: 0 ... 15, step: 1)
                    .tint(Color("HighlightColor"))
            }
            
        }
        .frame(height: 37)
        .padding(.horizontal)
    }
}
