//
//  DashboardSensorDataTypePicker.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardSensorDataTypePicker: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(SensorDataType.allCases) {
                        DashboardSensorDataPickerItem(sensorDataTypeSelection: $dashboardViewModel.sensorDataTypeSelection, tab: $0)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.white)
            Divider()
                .overlay(Color.red.opacity(0.01))
        }
    }
}

struct DashboardSensorDataPickerItem: View {
    @Namespace var namespace
    @Binding var sensorDataTypeSelection: SensorDataType
    var tab: SensorDataType

    var body: some View {
        Button {
            sensorDataTypeSelection = tab
        } label: {
            VStack(spacing: 5) {
                if sensorDataTypeSelection == tab {
                    Text(tab.rawValue)
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(Color("HighlightColor"))
                    Color("HighlightColor")
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Text(tab.rawValue)
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(Color.black)
                    Color.clear.frame(height: 3)
                }
            }
            .animation(.spring(), value: self.sensorDataTypeSelection)
        }
        .buttonStyle(.plain)
    }
}

enum SensorDataType: String, CaseIterable, Identifiable {
    var id: Self {
        self
    }

    case moisture = "Moisture", battery = "Battery", temperature = "Temperature", info = "Info"
}
