//
//  SensorListApi.swift
//  AquaTerra
//
//  Created by Davincci on 10/9/2023.
//

import Foundation

final class SensorListApi {
    static let shared = SensorListApi()
    
    struct Constants {
        static let fieldDataURL = URL(string: "https://webapp.aquaterra.cloud/api/field")
        static let sensorDataURL = URL(string: "https://webapp.aquaterra.cloud/api/sensor/field")
    }
    
    private init() {}
    
    public func getTopSensors(completion: @escaping (Result<[FieldData], Error>) -> Void) {
        guard let url = Constants.fieldDataURL else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonDict: [String: String] = ["userName":"demo"]
        
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
        
        let jsonDict: [String: Any] = ["userName": "demo", "fieldId": fieldId]
        
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

struct SensorData: Codable {
    let sensor_id: String
    let gateway_id: String?
    let field_id: String
    let geom: String
    let datetime: String
    let is_active: Bool
    let has_notified: Bool
    let username: String
    let sleeping: Int
    let alias: String?
    let points: String
    let field_name: String
}
