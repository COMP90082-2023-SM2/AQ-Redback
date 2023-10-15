//
//  DashboardDetailView.swift
//  AquaTerra
//
//

import Charts
import SwiftUI

struct DashboardDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    @State var isTemperatureSelected = true
    @State var isWiltingPointSelected = false
    @State var isFieldCapacitySelected = false
    @State var isSaturationPointSelected = false
    @State var isMoistureDepth50Selected = true
    @State var isMoistureDepth100Selected = true
    @State var isMoistureDepth150Selected = true
    @State var chartDateSelection: Date?
    @State var chartDepth50MoistureSelection: MoistureChartItem?
    @State var chartDepth100MoistureSelection: MoistureChartItem?
    @State var chartDepth150MoistureSelection: MoistureChartItem?
    @State var chartTemperatureSelection: TemperatureChartItem?
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Avg Soil Moisture/Temperature Variation")
                        .font(.custom("OpenSans-ExtraBold", size: 14))
                    Spacer()
                    Button {
                    } label: {
                        Image("download-2-fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .frame(width: 40, height: 40)
                            .background(Color("GreenHightlight"))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        DashboardChartToggleButton(isSelected: $isTemperatureSelected, text: "Temperature")
                        DashboardChartToggleButton(isSelected: $isWiltingPointSelected, text: "Wilting Point")
                        DashboardChartToggleButton(isSelected: $isFieldCapacitySelected, text: "Field Capacity")
                        DashboardChartToggleButton(isSelected: $isSaturationPointSelected, text: "Saturation Point")
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        DashboardChartToggleButton(isSelected: $isMoistureDepth50Selected, text: "30-50 cm")
                        DashboardChartToggleButton(isSelected: $isMoistureDepth100Selected, text: "100cm")
                        DashboardChartToggleButton(isSelected: $isMoistureDepth150Selected, text: "150cm")
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                VStack(spacing: 0) {
                    Chart {
                        if isMoistureDepth50Selected {
                            ForEach(dashboardViewModel.depth50MoisturesForChart) { moisture in
                                LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                                    .foregroundStyle(by: .value("Type", "M50Moisture"))
                            }
                            .interpolationMethod(.catmullRom)
                        }

                        if isMoistureDepth100Selected {
                            ForEach(dashboardViewModel.depth100MoisturesForChart) { moisture in
                                LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                                    .foregroundStyle(by: .value("Type", "M100Moisture"))
                            }
                            .interpolationMethod(.catmullRom)
                        }

                        if isMoistureDepth150Selected {
                            ForEach(dashboardViewModel.depth150MoisturesForChart) { moisture in
                                LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                                    .foregroundStyle(by: .value("Type", "M150Moisture"))
                            }
                            .interpolationMethod(.catmullRom)
                        }

                        if isTemperatureSelected {
                            ForEach(dashboardViewModel.temperatureForChart) { temperature in
                                LineMark(x: .value("Date", temperature.date), y: .value("Temperature", temperature.value * 3.125))
                                    .foregroundStyle(by: .value("Type", "Temperature"))
                            }
                            .interpolationMethod(.catmullRom)
                        }

                        if let chartDateSelection {
                            RuleMark(x: .value("Date", chartDateSelection))
                                .offset(yStart: 60)
                                .annotation {
                                    VStack(alignment: .leading) {
                                        Text(formateDate(date: chartDateSelection))
                                        if isTemperatureSelected {
                                            Text("Temperature: \(formateNumber(chartTemperatureSelection!.value))℃")
                                                .foregroundColor(Color("TemperatureColor"))
                                        }
                                        if isMoistureDepth50Selected {
                                            Text("Moisture 30-50cm underground: \(formateNumber(chartDepth50MoistureSelection!.value))%")
                                                .foregroundColor(Color("M50Color"))
                                        }
                                        if isMoistureDepth100Selected {
                                            Text("Moisture 100cm underground: \(formateNumber(chartDepth100MoistureSelection!.value))%")
                                                .foregroundColor(Color("M100Color"))
                                        }
                                        if isMoistureDepth150Selected {
                                            Text("Moisture 150cm underground: \(formateNumber(chartDepth150MoistureSelection!.value))%")
                                                .foregroundColor(Color("M150Color"))
                                        }
                                    }
                                    .padding(3)
                                    .font(.system(size: 8))
                                    .background(.white)
                                }
                        }
                    }
                    .chartForegroundStyleScale([
                        "Temperature": Color("TemperatureColor"),
                        "M50Moisture": Color("M50Color"),
                        "M100Moisture": Color("M100Color"),
                        "M150Moisture": Color("M150Color"),
                    ])
                    .chartLegend(.hidden)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: [0, 25, 50]) { it in
                            AxisGridLine()
                            AxisValueLabel("\(it.as(Int.self)!)%")
                        }
                        AxisMarks(position: .trailing, values: [0, 12.5, 25, 37.5, 50]) { it in
                            AxisValueLabel("\(Int(it.as(Double.self)! / 3.125))℃")
                        }
                    }
                    .frame(height: 300)
                    .padding()
                    .chartBackground { _ in
                        Color("ChartBackground")
                    }
                    .chartOverlay { chart in
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            guard isMoistureDepth50Selected || isMoistureDepth100Selected || isMoistureDepth150Selected || isTemperatureSelected else {
                                                return
                                            }
                                            let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                            guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                                return
                                            }

                                            guard let date = chart.value(atX: currentX, as: Date.self) else {
                                                return
                                            }
                                            let foundDate = dashboardViewModel.zeroSecond(date: date)
                                            for s in Array(dashboardViewModel.depth50MoisturesForChartDict.keys) {
                                                if abs(foundDate.distance(to: s)) < 60 * 30 {
                                                    chartDateSelection = s
                                                    if isMoistureDepth50Selected {
                                                        chartDepth50MoistureSelection = dashboardViewModel.depth50MoisturesForChartDict[s]!
                                                    }
                                                    if isMoistureDepth100Selected {
                                                        chartDepth100MoistureSelection = dashboardViewModel.depth100MoisturesForChartDict[s]!
                                                    }
                                                    if isMoistureDepth150Selected {
                                                        chartDepth150MoistureSelection = dashboardViewModel.depth150MoisturesForChartDict[s]!
                                                    }
                                                    if isTemperatureSelected {
                                                        chartTemperatureSelection = dashboardViewModel.temperatureForChartDict[s]!
                                                    }
                                                    return
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            chartDateSelection = nil
                                            chartDepth50MoistureSelection = nil
                                            chartDepth100MoistureSelection = nil
                                            chartDepth150MoistureSelection = nil
                                            chartTemperatureSelection = nil
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard isMoistureDepth50Selected || isMoistureDepth100Selected || isMoistureDepth150Selected || isTemperatureSelected else {
                                                return
                                            }
                                            let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                            guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                                return
                                            }

                                            guard let date = chart.value(atX: currentX, as: Date.self) else {
                                                return
                                            }
                                            let foundDate = dashboardViewModel.zeroSecond(date: date)
                                            for s in Array(dashboardViewModel.depth50MoisturesForChartDict.keys) {
                                                if abs(foundDate.distance(to: s)) < 60 * 10 {
                                                    chartDateSelection = s
                                                    if isMoistureDepth50Selected {
                                                        chartDepth50MoistureSelection = dashboardViewModel.depth50MoisturesForChartDict[s]!
                                                    }
                                                    if isMoistureDepth100Selected {
                                                        chartDepth100MoistureSelection = dashboardViewModel.depth100MoisturesForChartDict[s]!
                                                    }
                                                    if isMoistureDepth150Selected {
                                                        chartDepth150MoistureSelection = dashboardViewModel.depth150MoisturesForChartDict[s]!
                                                    }
                                                    if isTemperatureSelected {
                                                        chartTemperatureSelection = dashboardViewModel.temperatureForChartDict[s]!
                                                    }
                                                    return
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            chartDateSelection = nil
                                            chartDepth50MoistureSelection = nil
                                            chartDepth100MoistureSelection = nil
                                            chartDepth150MoistureSelection = nil
                                            chartTemperatureSelection = nil
                                        }
                                )
                        }
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100))], alignment: .leading) {
                        if isTemperatureSelected {
                            HStack {
                                Circle()
                                    .frame(width: 5, height: 5)
                                Text("Soil Temperature")
                            }
                            .foregroundColor(Color("TemperatureColor"))
                        }
                        if isMoistureDepth50Selected {
                            HStack {
                                Circle()
                                    .frame(width: 5, height: 5)
                                Text("Moisture 30-50cm")
                            }
                            .foregroundColor(Color("M50Color"))
                        }
                        if isMoistureDepth100Selected {
                            HStack {
                                Circle()
                                    .frame(width: 5, height: 5)
                                Text("Moisture 100cm")
                            }
                            .foregroundColor(Color("M100Color"))
                        }

                        if isMoistureDepth150Selected {
                            HStack {
                                Circle()
                                    .frame(width: 5, height: 5)
                                Text("Moisture 150cm")
                            }
                            .foregroundColor(Color("M150Color"))
                        }
                    }
                    .font(.custom("OpenSans-Regular", size: 8))
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .background(Color("ChartBackground"))
                }
                WeatherView(viewModel: dashboardViewModel)
            }
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackView()
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(width: 70, height: 17)
            }
        }
        .onAppear {
            BaseBarModel.share.hidden()
            dashboardViewModel.updateChart()
        }
    }

    private func formateDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    private func formateNumber(_ number: Double) -> String {
        return String(format: "%.2f", number)
    }
}

struct DashboardChartToggleButton: View {
    @Binding var isSelected: Bool
    let text: String
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            if isSelected {
                Text(text)
                    .font(.custom("OpenSans-Regular", size: 12))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color("GreenHightlight"))
                    .clipShape(Capsule(style: .continuous))
            } else {
                Text(text)
                    .font(.custom("OpenSans-Regular", size: 12))
                    .foregroundColor(Color("GreenHightlight"))
                    .padding(8)
                    .clipShape(Capsule(style: .continuous))
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke()
                            .fill(Color("GreenHightlight"))
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

struct Demo: Identifiable {
    var id: Int {
        index
    }

    let index: Int
    let value: Double
}
