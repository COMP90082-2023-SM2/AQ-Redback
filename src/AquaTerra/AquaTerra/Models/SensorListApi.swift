//
//  SensorListApi.swift
//  AquaTerra
//
//  Created by Davincci on 10/9/2023.
//

import Foundation
import CoreLocation


final class SensorListApi {
    static let shared = SensorListApi()
    var currentUserUsername: String?
    
    struct Constants {
        static let fieldDataURL = URL(string: "https://webapp.aquaterra.cloud/api/field")
        static let sensorDataURL = URL(string: "https://webapp.aquaterra.cloud/api/sensor/field")
        static let createSensor = URL(string: "https://webapp.aquaterra.cloud/api/sensor/v2/new")
    }
    
    private init() {}
    
    public func getTopSensors(completion: @escaping (Result<[FieldData], Error>) -> Void) {
        guard let url = Constants.fieldDataURL else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonDict: [String: String] = ["userName": currentUserUsername ?? ""]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    //print("Response JSON: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.success(result.data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getSensorData(fieldId: String, completion: @escaping (Result<SensorDataResponse, Error>) -> Void) {
        guard let url = Constants.sensorDataURL else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonDict: [String: Any] = ["userName": currentUserUsername ?? "", "fieldId": fieldId]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(SensorDataResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func createSensor(sensorID: String, fieldID: String, coordinate: CLLocationCoordinate2D, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = Constants.createSensor else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let sensorData: [String: Any] = [
            "username": currentUserUsername ?? "",
            "fieldId": fieldID,
            "sensorId": sensorID,
            "geom": [
                "type": "Feature",
                "geometry": [
                    "type": "Point",
                    "coordinates": [
                        String(coordinate.longitude),
                        String(coordinate.latitude)
                    ]
                ] as [String : Any],
                "properties": Dictionary<String, Any>()
            ] as [String : Any]
        ]

        
        if let jsonData = try? JSONSerialization.data(withJSONObject: sensorData) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Cooordinate Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        task.resume()
    }

    
    public func deleteSensor(sensorID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://webapp.aquaterra.cloud/api/sensor/\(sensorID)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    public func editSensor(sensorData: SensorData, coordinate: CLLocationCoordinate2D?, completion: @escaping (Result<Void, Error>) -> Void) {
        let sensorID = sensorData.sensor_id
        
        guard let url = URL(string: "https://webapp.aquaterra.cloud/api/sensor/\(sensorID)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        var sensorUpdateData: [String: Any] = [
            "username": currentUserUsername ?? "",
            "sensorId": sensorID,
            "alias": sensorData.alias,
            "sleeping": sensorData.sleeping
        ]
        
        if let coordinate = coordinate {
            sensorUpdateData["geom"] = [
                    "type": "Feature",
                    "geometry": [
                        "type": "Point",
                        "coordinates": [
                            String(coordinate.longitude),
                            String(coordinate.latitude)
                        ]
                    ] as [String : Any],
                    "properties": Dictionary<String, Any>()
            ]
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: sensorUpdateData) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Edit Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Edit Sensor Error: \(error)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    public func getSensorDetail(username: String, fieldId: String, sensorId: String, completion: @escaping (Result<SensorDetail, Error>) -> Void) {
        guard let url = URL(string: "https://webapp.aquaterra.cloud/api/sensor/\(sensorId)?username=\(username)&fieldId=\(fieldId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        print("getSensorDetail called with URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("getSensorDetail error: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("getSensorDetail: No data received")
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }

            do {
                let response = try JSONDecoder().decode(SensorDetailResponse.self, from: data)
                let sensorDetail = response.sensor
                print("getSensorDetail success with sensorDetail: \(sensorDetail)")
                completion(.success(sensorDetail))
            } catch {
                print("getSensorDetail error: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
    }




}

// Models
struct APIResponse: Codable {
    let data: [FieldData]
}

struct FieldData: Codable {
    let points: String
    let field_name: String
    let crop_type: String?
    let soil_type: String?
    let farm_name: String
    let username: String
    let geom: String
    let elevation: Int?
    let field_id: String
}

struct SensorDataResponse: Codable {
    let data: [SensorData]
}

struct SensorData: Codable, Equatable, Identifiable {
    var id: String { sensor_id }
    let sensor_id: String
    let gateway_id: String?
    let field_id: String
    let geom: String?
    let datetime: String?
    let is_active: Bool
    let has_notified: Bool
    let username: String?
    let sleeping: Int?
    let alias: String?
    let points: String?
    let field_name: String
    
    static func == (lhs: SensorData, rhs: SensorData) -> Bool {
        return lhs.sensor_id == rhs.sensor_id && lhs.field_id == rhs.field_id
    }
}

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

struct SensorDetailResponse: Codable {
    let sensor: SensorDetail
}

struct SensorDetail: Codable {
    let sensor_id: String
    let gateway_id: String?
    let field_id: String
    let geom: String?
    let datetime: String?
    let is_active: Bool
    let has_notified: Bool
    let username: String?
    let sleeping: Int?
    let alias: String?
    let points: String?
}
