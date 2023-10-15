//
//  DashboardViewModel.swift
//  AquaTerra
//
//

import Expression
import Foundation
import MapKit

class DashboardViewModel: ObservableObject {
    @Published var isWarningPresented = false
    @Published var warnedSensors = "11"
    @Published var sensorDataTypeSelection: SensorDataType = .moisture
    @Published var moistureDepthSelection = MoistureDepth.depth50
    @Published var fieldSelection = FieldData(points: "", field_name: "", crop_type: nil, soil_type: nil, farm_name: "", username: "", geom: "", elevation: nil, field_id: "")
    @Published var fields: [FieldData] = []
    @Published var sensorSelection = SensorData(sensor_id: "", gateway_id: nil, field_id: "", geom: nil, datetime: nil, is_active: false, has_notified: false, username: nil, sleeping: nil, alias: nil, points: nil, field_name: "")
    @Published var sensors: [SensorData] = []
    @Published var moistures: [MoistureData] = []
    @Published var latestRecord: MoistureData?
    @Published var coordinateRegion = MKCoordinateRegion()
    @Published var annotations: [MKAnnotation] = []
    @Published var addDays = 15.0

    @Published var batteryForChart: [BatteryChartItem] = []
    @Published var depthMosturesForChart: [DepthMoistureChartItem] = []
    @Published var dateDepth50MoisturesForChart: [DateMoistureChartItem] = []
    @Published var dateDepth100MoisturesForChart: [DateMoistureChartItem] = []
    @Published var dateDepth150MoisturesForChart: [DateMoistureChartItem] = []
    @Published var dateTemperatureForChart: [DateTemperatureChartItem] = []
    @Published var evaporationsForChart: [EvaporationChartItem] = []

    var depth50MoisturesForChartDict: [String: DepthMoistureChartItem] = [:]
    var depth100MoisturesForChartDict: [String: DepthMoistureChartItem] = [:]
    var depth150MoisturesForChartDict: [String: DepthMoistureChartItem] = [:]
    var dateDepth50MoisturesForChartDict: [Date: DateMoistureChartItem] = [:]
    var dateDepth100MoisturesForChartDict: [Date: DateMoistureChartItem] = [:]
    var dateDepth150MoisturesForChartDict: [Date: DateMoistureChartItem] = [:]
    var dateTemperatureForChartDict: [Date: DateTemperatureChartItem] = [:]
    var batteryForChartDict: [Date: BatteryChartItem] = [:]
    var evaporationsForChartDict: [Date: EvaporationChartItem] = [:]

    var sensorFormulas: [String: SensorFormulaData] = [:]

    let iso8601DateFormatter = ISO8601DateFormatter()
    init() {
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    func updateChart() {
        dateDepth50MoisturesForChart.removeAll()
        dateDepth100MoisturesForChart.removeAll()
        dateDepth150MoisturesForChart.removeAll()
        dateTemperatureForChart.removeAll()
        depthMosturesForChart.removeAll()
        depth50MoisturesForChartDict.removeAll()
        depth100MoisturesForChartDict.removeAll()
        depth150MoisturesForChartDict.removeAll()
        dateDepth50MoisturesForChartDict.removeAll()
        dateDepth100MoisturesForChartDict.removeAll()
        dateDepth150MoisturesForChartDict.removeAll()
        dateTemperatureForChartDict.removeAll()
        batteryForChart.removeAll()
        batteryForChartDict.removeAll()
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let today = Date.now
        let theDayBeforeYesterday = today.advanced(by: -24 * 60 * 60 * 2)
        let yesterday = today.advanced(by: -24 * 60 * 60)

        for moisture in moistures {
            if moisture.sensor_id == sensorSelection.sensor_id {
                let date = zeroSecond(date: df.date(from: moisture.time)!)
                let moistureItem50 = DateMoistureChartItem(date: date, value: moisture.moistureDepth50)
                let moistureItem100 = DateMoistureChartItem(date: date, value: moisture.moistureDepth100)
                let moistureItem150 = DateMoistureChartItem(date: date, value: moisture.moistureDepth150)
                dateDepth50MoisturesForChartDict[date] = moistureItem50
                dateDepth50MoisturesForChart.append(moistureItem50)
                dateDepth100MoisturesForChartDict[date] = moistureItem100
                dateDepth100MoisturesForChart.append(moistureItem100)
                dateDepth150MoisturesForChartDict[date] = moistureItem150
                dateDepth150MoisturesForChart.append(moistureItem150)

                let temperatureItem = DateTemperatureChartItem(date: date, value: moisture.temperature)
                dateTemperatureForChart.append(temperatureItem)
                dateTemperatureForChartDict[date] = temperatureItem

                let batteryItem = BatteryChartItem(date: date, value: moisture.battery_vol)
                batteryForChart.append(batteryItem)
                batteryForChartDict[date] = batteryItem

                if Calendar.current.isDate(date, inSameDayAs: today) {
                    let depthMoistureItem0 = DepthMoistureChartItem(date: date, depth: -50, value: moisture.moistureDepth50)
                    let depthMoistureItem1 = DepthMoistureChartItem(date: date, depth: -100, value: moisture.moistureDepth100)
                    let depthMoistureItem2 = DepthMoistureChartItem(date: date, depth: -150, value: moisture.moistureDepth150)
                    depthMosturesForChart.append(contentsOf: [depthMoistureItem0, depthMoistureItem1, depthMoistureItem2])
                    depth50MoisturesForChartDict["Today"] = depthMoistureItem0
                    depth100MoisturesForChartDict["Today"] = depthMoistureItem1
                    depth150MoisturesForChartDict["Today"] = depthMoistureItem2
                } else if Calendar.current.isDate(date, inSameDayAs: yesterday) {
                    let depthMoistureItem0 = DepthMoistureChartItem(date: date, depth: -50, value: moisture.moistureDepth50)
                    let depthMoistureItem1 = DepthMoistureChartItem(date: date, depth: -100, value: moisture.moistureDepth100)
                    let depthMoistureItem2 = DepthMoistureChartItem(date: date, depth: -150, value: moisture.moistureDepth150)
                    depthMosturesForChart.append(contentsOf: [depthMoistureItem0, depthMoistureItem1, depthMoistureItem2])
                    depth50MoisturesForChartDict["Yesterday"] = depthMoistureItem0
                    depth100MoisturesForChartDict["Yesterday"] = depthMoistureItem1
                    depth150MoisturesForChartDict["Yesterday"] = depthMoistureItem2
                } else if Calendar.current.isDate(date, inSameDayAs: theDayBeforeYesterday) {
                    let depthMoistureItem0 = DepthMoistureChartItem(date: date, depth: -50, value: moisture.moistureDepth50)
                    let depthMoistureItem1 = DepthMoistureChartItem(date: date, depth: -100, value: moisture.moistureDepth100)
                    let depthMoistureItem2 = DepthMoistureChartItem(date: date, depth: -150, value: moisture.moistureDepth150)
                    depthMosturesForChart.append(contentsOf: [depthMoistureItem0, depthMoistureItem1, depthMoistureItem2])
                    depth50MoisturesForChartDict["BeforeYesterday"] = depthMoistureItem0
                    depth100MoisturesForChartDict["BeforeYesterday"] = depthMoistureItem1
                    depth150MoisturesForChartDict["BeforeYesterday"] = depthMoistureItem2
                }
            }
        }
    }

    func updateMap() {
        if sensorDataTypeSelection == .info {
            let location = getFieldLocation(pointsStr: fieldSelection.points)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = fieldSelection.field_name
            pointAnnotation.coordinate = location!.coordinate
            annotations = [pointAnnotation]
        } else {
            annotations = moistures.filter({ moistureData in
                let endDate = Calendar.current.date(byAdding: .day, value: Int(addDays) - 15, to: .now)
                return iso8601DateFormatter.date(from: moistureData.time)?.compare(endDate!) == .orderedAscending
            }).map { it in
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = it.sensor_id
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: it.latitude, longitude: it.longitude)
                switch sensorDataTypeSelection {
                case .moisture:
                    switch moistureDepthSelection {
                    case .depth50:
                        pointAnnotation.subtitle = String(formateNumber(it.moistureDepth50)) + "%"
                    case .depth100:
                        pointAnnotation.subtitle = String(formateNumber(it.moistureDepth100)) + "%"
                    case .depth150:
                        pointAnnotation.subtitle = String(formateNumber(it.moistureDepth150)) + "%"
                    }
                case .battery:
                    pointAnnotation.subtitle = String(it.battery_vol) + "V"
                case .temperature:
                    pointAnnotation.subtitle = String(it.temperature) + "℃"
                default:
                    print("")
                }
                return pointAnnotation
            }
        }
    }

    @MainActor
    func fetchData() async throws {
        fields = try await SensorListApi.shared.getFields()
        if !fields.isEmpty {
            fieldSelection = fields[0]
            try await fetchFieldData()
        } else {
            fieldSelection = FieldData(points: "", field_name: "", crop_type: nil, soil_type: nil, farm_name: "", username: "", geom: "", elevation: nil, field_id: "")
        }
    }

    @MainActor
    func fetchFieldData() async throws {
        if let location = getFieldLocation(pointsStr: fieldSelection.points) {
            coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        }
        sensors = try! await SensorListApi.shared.getSensors(fieldId: fieldSelection.field_id)
        if !sensors.isEmpty {
            sensorSelection = sensors[0]
            async let sensorFormulasFuture = getSensorFormulas(sensorIds: sensors.map({ $0.sensor_id }))
            async let localMoisturesFuture = getMoistures(fieldName: fieldSelection.field_name)
            sensorFormulas = try await sensorFormulasFuture
            let localMoistures = try await localMoisturesFuture
            moistures = localMoistures.map({ moisture in
                transferMoisture(moisture: moisture, sensorFormula: sensorFormulas[moisture.sensor_id]!)
            })
            Task.detached {
                if self.moistures.contains(where: { $0.battery_vol < 3.4 }) {
                    Task { @MainActor in
                        self.isWarningPresented = true
                    }
                    let warnSensor = self.moistures.map { $0.sensor_id }
                    if let firstWarnedSensor = warnSensor.first {
                        self.warnedSensors = firstWarnedSensor
                    }
                }
            }
        } else {
            sensorSelection = SensorData(sensor_id: "", gateway_id: nil, field_id: "", geom: nil, datetime: nil, is_active: false, has_notified: false, username: nil, sleeping: nil, alias: nil, points: nil, field_name: "")
        }
    }

    @MainActor
    func fetchLatestRecord() async throws {
        if let moisture = try await SensorListApi.shared.getMoisture(fieldName: fieldSelection.field_name, sensorId: sensorSelection.sensor_id) {
            let sensorFormula = sensorFormulas[moisture.sensor_id]!
            latestRecord = transferMoisture(moisture: moisture, sensorFormula: sensorFormula)
        }
    }
    
    @MainActor
    func fetchEvaporations() async throws {
        evaporationsForChart.removeAll()
        evaporationsForChartDict.removeAll()
        let evaporations = try await SensorListApi.shared.getEvaporations(fieldId: fieldSelection.field_id)
        for evaporation in evaporations {
            let df = DateFormatter()
            df.dateFormat = "MM-dd-yyyy"
            let date = df.date(from: evaporation.date)!
            let value = evaporation.evaporation
            let item = EvaporationChartItem(date: date, value: value)
            evaporationsForChart.append(item)
            evaporationsForChartDict[date] = item
        }
    }

    private func getSensorFormulas(sensorIds: [String]) async throws -> [String: SensorFormulaData] {
        try await withThrowingTaskGroup(of: (String, SensorFormulaData).self, returning: [String: SensorFormulaData].self) { group in
            var results: [String: SensorFormulaData] = [:]
            for sensorId in sensorIds {
                group.addTask {
                    let sensorFormulaData = try await SensorListApi.shared.getSensorFormula(sensorId: sensorId)
                    return (sensorId, sensorFormulaData)
                }
            }
            for try await result in group {
                results[result.0] = result.1
            }
            return results
        }
    }

    private func getMoistures(fieldName: String) async throws -> [MoistureData] {
      
        return try await SensorListApi.shared.getMoistures(fieldName: fieldSelection.field_name)
    }

    private func getFieldLocation(pointsStr: String) -> CLLocation? {
        if let jsonData = pointsStr.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let coordinates = jsonObject["coordinates"] as? [[[Double]]] {
                    var coordinatesArray: [CLLocationCoordinate2D] = []
                    for coordinate in coordinates {
                        for coord in coordinate {
                            if coord.count == 2 {
                                let latitude = coord[1]
                                let longitude = coord[0]
                                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                coordinatesArray.append(coordinate)
                            }
                        }
                    }
                    if let centerCoordinate = calculatePolygonCenter(coordinates: coordinatesArray) {
                        return centerCoordinate
                    } else {
                        return nil
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    private func calculatePolygonCenter(coordinates: [CLLocationCoordinate2D]) -> CLLocation? {
        guard !coordinates.isEmpty else {
            return nil
        }

        var totalLatitude: CLLocationDegrees = 0
        var totalLongitude: CLLocationDegrees = 0

        for coordinate in coordinates {
            totalLatitude += coordinate.latitude
            totalLongitude += coordinate.longitude
        }

        let centerLatitude = totalLatitude / Double(coordinates.count)
        let centerLongitude = totalLongitude / Double(coordinates.count)

        return CLLocation(latitude: centerLatitude, longitude: centerLongitude)
    }

    public func zeroSecond(date: Date) -> Date {
        var ds = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        ds.second = 0
        return Calendar.current.date(from: ds)!
    }

    private func transferMoisture(moisture: MoistureData, sensorFormula: SensorFormulaData) -> MoistureData {
        var scope: [String: Double] = [:]
        let parameters = sensorFormula.parameter.split(separator: ",")
        for index in parameters.indices {
            scope["x\(index + 1)"] = Double(parameters[index])
        }
        var scope0 = scope
        scope0["val"] = max(moisture.cap50, sensorFormula.lowest_adt)
        var scope1 = scope
        scope1["val"] = max(moisture.cap100, sensorFormula.lowest_adt)
        var scope2 = scope
        scope2["val"] = max(moisture.cap150, sensorFormula.lowest_adt)
        var newMoisture = moisture
        newMoisture.moistureDepth50 = evaluateExpression(formula: sensorFormula.formula, scope: scope0) * 100
        newMoisture.moistureDepth100 = evaluateExpression(formula: sensorFormula.formula, scope: scope1) * 100
        newMoisture.moistureDepth150 = evaluateExpression(formula: sensorFormula.formula, scope: scope2) * 100
        return newMoisture
    }

    func evaluateExpression(formula: String, scope: [String: Double]) -> Double {
        let val = " \(scope["val"] ?? 0) "
        let x1 = " \(scope["x1"] ?? 0) "
        let x2 = " \(scope["x2"] ?? 0) "
        let format = formula.replacingOccurrences(of: "val", with: val).replacingOccurrences(of: "x1", with: x1).replacingOccurrences(of: "x2", with: x2)
        let expression = Expression(format, symbols: [.infix("^"): { pow($0[0], $0[1]) }])
        let result = try? expression.evaluate()
        if let result = result {
            return result
        } else {
            return 0
        }
    }

    private func formateNumber(_ number: Double) -> String {
        return String(format: "%.2f", number)
    }
}

struct DateMoistureChartItem: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct DateTemperatureChartItem: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct DepthMoistureChartItem: Identifiable {
    let id = UUID()
    let date: Date
    let depth: Int
    let value: Double
}

struct BatteryChartItem: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct EvaporationChartItem: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
