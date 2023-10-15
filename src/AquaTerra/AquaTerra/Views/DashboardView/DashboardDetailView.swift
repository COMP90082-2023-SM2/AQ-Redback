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
    @State var chartDateMoistureSelection: Date?
    @State var chartDepth50MoistureSelection: DateMoistureChartItem?
    @State var chartDepth100MoistureSelection: DateMoistureChartItem?
    @State var chartDepth150MoistureSelection: DateMoistureChartItem?
    @State var chartTemperatureSelection: DateTemperatureChartItem?
    @State var chartDepthSelection: Int?
    @State var chartBatterySelection: Date?
    @State var chartEvaporationSelection: Date?
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                dateMoistureChartView
                depthMoistureChartView
                batteryLevelChartView
                evaporationChartView
                // WeatherView(viewModel: dashboardViewModel)
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
            Task {
               try? await dashboardViewModel.fetchEvaporations()
            }
        }
    }

    @ViewBuilder
    var dateMoistureChartView: some View {
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
                    ForEach(dashboardViewModel.dateDepth50MoisturesForChart) { moisture in
                        LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                            .foregroundStyle(by: .value("Type", "M50Moisture"))
                    }
                    .interpolationMethod(.catmullRom)
                }

                if isMoistureDepth100Selected {
                    ForEach(dashboardViewModel.dateDepth100MoisturesForChart) { moisture in
                        LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                            .foregroundStyle(by: .value("Type", "M100Moisture"))
                    }
                    .interpolationMethod(.catmullRom)
                }

                if isMoistureDepth150Selected {
                    ForEach(dashboardViewModel.dateDepth150MoisturesForChart) { moisture in
                        LineMark(x: .value("Date", moisture.date), y: .value("Moisture", moisture.value))
                            .foregroundStyle(by: .value("Type", "M150Moisture"))
                    }
                    .interpolationMethod(.catmullRom)
                }

                if isTemperatureSelected {
                    ForEach(dashboardViewModel.dateTemperatureForChart) { temperature in
                        LineMark(x: .value("Date", temperature.date), y: .value("Temperature", temperature.value * 3.125))
                            .foregroundStyle(by: .value("Type", "Temperature"))
                    }
                    .interpolationMethod(.catmullRom)
                }

                if let chartDateMoistureSelection {
                    RuleMark(x: .value("Date", chartDateMoistureSelection))
                        .offset(yStart: 60)
                        .annotation {
                            VStack(alignment: .leading) {
                                Text(formateDate(date: chartDateMoistureSelection))
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
                                    for s in Array(dashboardViewModel.dateDepth50MoisturesForChartDict.keys) {
                                        if abs(foundDate.distance(to: s)) < 60 * 30 {
                                            chartDateMoistureSelection = s
                                            if isMoistureDepth50Selected {
                                                chartDepth50MoistureSelection = dashboardViewModel.dateDepth50MoisturesForChartDict[s]!
                                            }
                                            if isMoistureDepth100Selected {
                                                chartDepth100MoistureSelection = dashboardViewModel.dateDepth100MoisturesForChartDict[s]!
                                            }
                                            if isMoistureDepth150Selected {
                                                chartDepth150MoistureSelection = dashboardViewModel.dateDepth150MoisturesForChartDict[s]!
                                            }
                                            if isTemperatureSelected {
                                                chartTemperatureSelection = dashboardViewModel.dateTemperatureForChartDict[s]!
                                            }
                                            return
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    chartDateMoistureSelection = nil
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
                                    for s in Array(dashboardViewModel.dateDepth50MoisturesForChartDict.keys) {
                                        if abs(foundDate.distance(to: s)) < 60 * 10 {
                                            chartDateMoistureSelection = s
                                            if isMoistureDepth50Selected {
                                                chartDepth50MoistureSelection = dashboardViewModel.dateDepth50MoisturesForChartDict[s]!
                                            }
                                            if isMoistureDepth100Selected {
                                                chartDepth100MoistureSelection = dashboardViewModel.dateDepth100MoisturesForChartDict[s]!
                                            }
                                            if isMoistureDepth150Selected {
                                                chartDepth150MoistureSelection = dashboardViewModel.dateDepth150MoisturesForChartDict[s]!
                                            }
                                            if isTemperatureSelected {
                                                chartTemperatureSelection = dashboardViewModel.dateTemperatureForChartDict[s]!
                                            }
                                            return
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    chartDateMoistureSelection = nil
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
    }

    @ViewBuilder
    var depthMoistureChartView: some View {
        HStack {
            Text("Moisture Depth Chart")
                .font(.custom("OpenSans-ExtraBold", size: 14))
            Spacer()
        }
        .padding(.horizontal)
        Chart {
            ForEach(dashboardViewModel.depthMosturesForChart) { item in
                PointMark(x: .value("Moisture", item.value - 32), y: .value("Depth", item.depth))
            }
            if let chartDepthSelection {
                RuleMark(y: .value("Depth", chartDepthSelection))
                    .annotation {
                        VStack(alignment: .leading) {
                            if chartDepthSelection == -50 {
                                Text("-50cm")
                                if let item = dashboardViewModel.depth50MoisturesForChartDict["BeforeYesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("TemperatureColor"))
                                }
                                if let item = dashboardViewModel.depth50MoisturesForChartDict["Yesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("BatteryVoltage4"))
                                }
                                if let item = dashboardViewModel.depth50MoisturesForChartDict["Today"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("M50Color"))
                                }
                            }
                            if chartDepthSelection == -100 {
                                Text("-100cm")
                                if let item = dashboardViewModel.depth100MoisturesForChartDict["BeforeYesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("TemperatureColor"))
                                }
                                if let item = dashboardViewModel.depth100MoisturesForChartDict["Yesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("BatteryVoltage4"))
                                }
                                if let item = dashboardViewModel.depth100MoisturesForChartDict["Today"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("M50Color"))
                                }
                            }
                            if chartDepthSelection == -150 {
                                Text("-150cm")
                                if let item = dashboardViewModel.depth150MoisturesForChartDict["BeforeYesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("TemperatureColor"))
                                }
                                if let item = dashboardViewModel.depth150MoisturesForChartDict["Yesterday"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("BatteryVoltage4"))
                                }
                                if let item = dashboardViewModel.depth150MoisturesForChartDict["Today"] {
                                    Text("\(formateDate(date: item.date)): \(formateNumber(item.value))%")
                                        .foregroundColor(Color("M50Color"))
                                }
                            }
                        }
                        .padding(3)
                        .font(.system(size: 8))
                        .background(.white)
                    }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 30)) { value in
                AxisGridLine()
                AxisValueLabel("\(value.as(Int.self)!)cm")
            }
        }
        .chartXAxis {
            AxisMarks(position: .top, values: [0, 2, 4, 6, 8, 10, 12, 14]) { value in
                AxisGridLine()
                AxisValueLabel("\(value.as(Int.self)! + 32)%")
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

                                let currentY = value.location.y - geometry[chart.plotAreaFrame].origin.y
                                guard currentY >= 0, currentY < chart.plotAreaSize.height else {
                                    return
                                }

                                guard let depth = chart.value(atY: currentY, as: Int.self) else {
                                    return
                                }

                                if abs(-50 - depth) < 5 {
                                    chartDepthSelection = -50
                                } else if abs(-100 - depth) < 5 {
                                    chartDepthSelection = -100
                                } else if abs(-150 - depth) < 5 {
                                    chartDepthSelection = -150
                                }
                            }
                            .onEnded { _ in
                                chartDepthSelection = nil
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in

                                let currentY = value.location.y - geometry[chart.plotAreaFrame].origin.y
                                guard currentY >= 0, currentY < chart.plotAreaSize.height else {
                                    return
                                }

                                guard let depth = chart.value(atX: currentY, as: Int.self) else {
                                    return
                                }

                                if abs(-50 - depth) < 5 {
                                    chartDepthSelection = -50
                                } else if abs(-100 - depth) < 5 {
                                    chartDepthSelection = -100
                                } else if abs(-150 - depth) < 5 {
                                    chartDepthSelection = -150
                                }
                            }
                            .onEnded { _ in
                                chartDepthSelection = nil
                            }
                    )
            }
        }
    }
    
    @ViewBuilder
    var batteryLevelChartView: some View {
        HStack {
            Text("Battery Level")
                .font(.custom("OpenSans-ExtraBold", size: 14))
            Spacer()
        }
        .padding(.horizontal)
        Chart {
            ForEach(dashboardViewModel.batteryForChart) { item in
                LineMark(x: .value("Date", item.date), y: .value("BatteryLevel", item.value))
            }
            .interpolationMethod(.catmullRom)
            if let chartBatterySelection {
                RuleMark(x: .value("Date", chartBatterySelection))
                    .offset(yStart: 30)
                    .annotation {
                        VStack(alignment: .leading) {
                            Text(formateDate(date: chartBatterySelection))
                            Text("Voltage: \(formateNumber(dashboardViewModel.batteryForChartDict[chartBatterySelection]!.value))V")
                                .foregroundColor(Color("BatteryLevelColor"))
                        }
                        .padding(3)
                        .font(.system(size: 8))
                        .background(.white)
                    }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: [0, 2, 4, 6, 8]) { it in
                AxisGridLine()
                AxisValueLabel("\(it.as(Int.self)!)V")
            }
        }
        .frame(height: 350)
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
                                let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                    return
                                }

                                guard let date = chart.value(atX: currentX, as: Date.self) else {
                                    return
                                }
                                let foundDate = dashboardViewModel.zeroSecond(date: date)
                                for s in Array(dashboardViewModel.batteryForChartDict.keys) {
                                    if abs(foundDate.distance(to: s)) < 60 * 30 {
                                        chartBatterySelection = s
                                        break
                                    }
                                }
                            }
                            .onEnded { _ in
                                chartBatterySelection = nil
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in

                                let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                    return
                                }

                                guard let date = chart.value(atX: currentX, as: Date.self) else {
                                    return
                                }
                                let foundDate = dashboardViewModel.zeroSecond(date: date)
                                for s in Array(dashboardViewModel.batteryForChartDict.keys) {
                                    if abs(foundDate.distance(to: s)) < 60 * 10 {
                                        chartBatterySelection = s
                                        break
                                    }
                                }
                            }
                            .onEnded { _ in
                                chartBatterySelection = nil
                            }
                    )
            }
        }
    }
    
    @ViewBuilder
    var evaporationChartView: some View {
        HStack {
            Text("Evaporation")
                .font(.custom("OpenSans-ExtraBold", size: 14))
            Spacer()
        }
        .padding(.horizontal)
        Chart {
            ForEach(dashboardViewModel.evaporationsForChart) { item in
                LineMark(x: .value("Date", item.date), y: .value("Evaporation", item.value))
            }
            .interpolationMethod(.catmullRom)
            if let chartEvaporationSelection {
                RuleMark(x: .value("Date", chartEvaporationSelection))
                    .offset(yStart: 30)
                    .annotation {
                        VStack(alignment: .leading) {
                            Text(formateDate(date: chartEvaporationSelection))
                            Text("Evaporation: \(formateNumber(dashboardViewModel.evaporationsForChartDict[chartEvaporationSelection]!.value))mm")
                                .foregroundColor(Color("BatteryLevelColor"))
                        }
                        .padding(3)
                        .font(.system(size: 8))
                        .background(.white)
                    }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: [0, 2, 4, 6, 8]) { it in
                AxisGridLine()
                AxisValueLabel("\(it.as(Int.self)!)mm")
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
                                let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                    return
                                }

                                guard let date = chart.value(atX: currentX, as: Date.self) else {
                                    return
                                }
                                let foundDate = dashboardViewModel.zeroSecond(date: date)
                                for s in Array(dashboardViewModel.evaporationsForChartDict.keys) {
                                    if abs(foundDate.distance(to: s)) < 60 * 30 {
                                        chartEvaporationSelection = s
                                        break
                                    }
                                }
                            }
                            .onEnded { _ in
                                chartEvaporationSelection = nil
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in

                                let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                    return
                                }

                                guard let date = chart.value(atX: currentX, as: Date.self) else {
                                    return
                                }
                                let foundDate = dashboardViewModel.zeroSecond(date: date)
                                for s in Array(dashboardViewModel.evaporationsForChartDict.keys) {
                                    if abs(foundDate.distance(to: s)) < 60 * 10 {
                                        chartEvaporationSelection = s
                                        break
                                    }
                                }
                            }
                            .onEnded { _ in
                                chartEvaporationSelection = nil
                            }
                    )
            }
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
