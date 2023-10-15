//
//  DashboardView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import Amplify
import MapKit
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    @Binding var user: AuthUser
    @StateObject var dashboardViewModel = DashboardViewModel()
    @State var isDashboardDetailPresented = false
    @State var isFetchingData = true
    @State var isFetchingLatestRecord = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomHeaderView(title: "Dashboard")
                VStack{
                    DashboardFieldPicker()
                    Spacer().frame(height: 15)
                    DashboardSensorDataTypePicker()
                    if !isFetchingData {
                        VStack(spacing: 15) {
                            ScrollView{
                                Spacer().frame(height: 15)
                                if dashboardViewModel.sensorDataTypeSelection == .moisture {
                                    DashboardMoistureDepthPicker()
                                }
                                if dashboardViewModel.sensorDataTypeSelection != .info {
                                    DashboardDateTimePicker()
                                }
                                DashboardMapView(dashboardViewModel: dashboardViewModel, coordinateRegion: dashboardViewModel.coordinateRegion, annotations: dashboardViewModel.annotations)
                                    .frame(height: 208)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .padding(.horizontal)
                                
                                Spacer().frame(height: 15)
                                if !dashboardViewModel.sensorSelection.sensor_id.isEmpty {
                                    DashboardSensorPicker()
                                    if isFetchingLatestRecord {
                                        ProgressView()
                                            .frame(height: 150)
                                    } else if let latestRecord = dashboardViewModel.latestRecord {
                                        Spacer().frame(height: 15)
                                        DashboardLatestRecordView(isDashboardDetailPresented: $isDashboardDetailPresented, record: latestRecord)
                                            .padding(.horizontal)
                                            .padding(.bottom, 100)
                                    }
                                }
                                
                            }
                           
                        }
                    }else{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                Spacer()
            }
            .overlay {
                if dashboardViewModel.isWarningPresented {
                    ZStack {
                        Color.black.opacity(0.2)
                        Text("Sensor battery low : \(dashboardViewModel.warnedSensors)")
                            .font(.system(size: 15))
                            .frame(width: 200, height: 100)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .onTapGesture {
                                dashboardViewModel.isWarningPresented = false
                            }
                    }
                    .ignoresSafeArea()
                }
            }
            .onChange(of: dashboardViewModel.fieldSelection) { _ in
                guard !isFetchingData else {
                    return
                }
                isFetchingData = true
                Task { @MainActor in
                    try? await dashboardViewModel.fetchFieldData()
                    dashboardViewModel.updateMap()
                    isFetchingData = false
                }
            }
            .onChange(of: dashboardViewModel.sensorSelection) { _ in
                isFetchingLatestRecord = true
                Task { @MainActor in
                    try await dashboardViewModel.fetchLatestRecord()
                    isFetchingLatestRecord = false
                }
            }
            .onChange(of: dashboardViewModel.sensorDataTypeSelection) { _ in
                dashboardViewModel.updateMap()
            }
            .onChange(of: dashboardViewModel.moistureDepthSelection) { _ in
                dashboardViewModel.updateMap()
            }
            .onChange(of: dashboardViewModel.addDays) { _ in
                dashboardViewModel.updateMap()
            }
            .task {
                if dashboardViewModel.moistures.isEmpty {
                    try? await dashboardViewModel.fetchData()
                    dashboardViewModel.updateMap()
                    isFetchingData = false
                }
            }
            .navigationDestination(isPresented: $isDashboardDetailPresented) {
                DashboardDetailView()
                    .environmentObject(dashboardViewModel)
            }
            .environmentObject(dashboardViewModel)
            .onAppear{
                BaseBarModel.share.show()
            }
        }
    }
}
