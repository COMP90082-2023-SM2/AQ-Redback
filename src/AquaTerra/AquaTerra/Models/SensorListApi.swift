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
        static let createSensorV1 = URL(string: "https://webapp.aquaterra.cloud/api/gateway/field")
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Create error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    // Successful response (status code in the 200-299 range)
                    completion(.success(()))
                    print("Create success")
                } else {
                    // Handle non-successful response here (status code 500)
                    let errorMessage = "HTTP status code \(httpResponse.statusCode)"
                    let error = NSError(domain: "YourErrorDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                    print("Create error: \(errorMessage)")
                }
            }
        }
        task.resume()
    }
    
    public func createSensorV1(fieldID: String, completion: @escaping (Result<GateWayResponse, Error>) -> Void) {
        
        guard let url = Constants.createSensorV1 else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonDict: [String: Any] = [
            "fieldId": fieldID,
            "username": currentUserUsername ?? ""
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("json error")
                completion(.failure(error))
            } else if let data = data {
                print("json correct")
                do {
                    let result = try JSONDecoder().decode(GateWayResponse.self, from: data)
                    print("Response JSON: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
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
    
    public func editSensor(sensorDetail: SensorDetail, coordinate: CLLocationCoordinate2D?, completion: @escaping (Result<Void, Error>) -> Void) {
        let sensorID = sensorDetail.sensor_id
        
        guard let url = URL(string: "https://webapp.aquaterra.cloud/api/sensor/\(sensorID)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Create the sensorUpdateData dictionary
        var sensorUpdateData: [String: Any] = [
            "geom": "{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[\(coordinate?.longitude ?? 0),\(coordinate?.latitude ?? 0)]},\"properties\":{}}",
            "sleeping": sensorDetail.sleeping,
            "alias": sensorDetail.alias
        ]
        
        // Convert sensorUpdateData to JSON data
        if let jsonData = try? JSONSerialization.data(withJSONObject: sensorUpdateData) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Edit Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Edit Sensor Error: \(error)")
                completion(.failure(error))
                return
            }
            
            // Check if there is response data
            guard let responseData = data else {
                print("Edit Sensor Error: No response data")
                completion(.failure(NSError(domain: "EditSensorErrorDomain", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("Edit Sensor Response JSON: \(jsonResponse)")
                }
                
                completion(.success(()))
            } catch {
                print("Edit Sensor Error: Failed to parse JSON response")
                completion(.failure(error))
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
    
    func checkGatewayAPI(gatewayIds: [String], completion: @escaping (Result<SetupGatewayResponse, Error>) -> Void) {
        let url = URL(string: "https://webapp.aquaterra.cloud/api/gateway/setup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = [
            "status": true,
            "gatewayIds": gatewayIds
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(SetupGatewayResponse.self, from: data)
                    print("data: ", decodedResponse)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    
    func fetchGatewaySensors(gatewayIds: [String], completion: @escaping (Result<GatewaySensorResponse, Error>) -> Void) {
        let url = URL(string: "https://webapp.aquaterra.cloud/api/gateway/sensors")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = [
            "gatewayIds": gatewayIds,
            "userName": currentUserUsername ?? ""
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GatewaySensorResponse.self, from: data)
                    print("Gatewaysensors: ", response)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }

    
    public func submitSensorV1(sensorId: String, gatewayId: String, fieldId: String, coordinate: CLLocationCoordinate2D, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://webapp.aquaterra.cloud/api/sensor/new") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let jsonDict: [String: Any] = [
            "sensorId": sensorId,
            "gatewayId": gatewayId,
            "fieldId": fieldId,
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

        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Create Sensor Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    // Successful response (status code in the 200-299 range)
                    completion(.success(()))
                    print("Create Sensor Success")
                } else {
                    // Handle non-successful response here (status code 500)
                    let errorMessage = "HTTP status code \(httpResponse.statusCode)"
                    let error = NSError(domain: "CreateSensorErrorDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                    print("Create Sensor Error: \(errorMessage)")
                }
            }
        }

        task.resume()
    }

    public func getFieldZone(userName: String, completion: @escaping (Result<[FieldData], Error>) -> Void) {
        guard let url = Constants.fieldDataURL else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonDict: [String: Any] = [
            "userName": currentUserUsername ?? ""
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("Create Field Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.data))
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
    var sleeping: Int?
    var alias: String?
    let points: String?
    var coordinate: CLLocationCoordinate2D?
    
    enum CodingKeys: String, CodingKey {
        case sensor_id, gateway_id, field_id, geom, datetime, is_active, has_notified, username, sleeping, alias, points
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sensor_id = try container.decode(String.self, forKey: .sensor_id)
        self.gateway_id = try container.decodeIfPresent(String.self, forKey: .gateway_id)
        self.field_id = try container.decode(String.self, forKey: .field_id)
        self.geom = try container.decodeIfPresent(String.self, forKey: .geom)
        self.datetime = try container.decodeIfPresent(String.self, forKey: .datetime)
        self.is_active = try container.decode(Bool.self, forKey: .is_active)
        self.has_notified = try container.decode(Bool.self, forKey: .has_notified)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.sleeping = try container.decodeIfPresent(Int.self, forKey: .sleeping)
        self.alias = try container.decodeIfPresent(String.self, forKey: .alias)
        self.points = try container.decodeIfPresent(String.self, forKey: .points)
        self.coordinate = nil  // Initialize coordinate as nil, you can set it later
    }
}

struct GateWayResponse: Codable {
    let data: [GateWayData]
}

struct GateWayData: Codable {
    let points: String
    let gateway_id: String
}

struct SetupGatewayResponse: Codable {
    let data: String
}

struct GatewaySensorResponse: Decodable {
    let data: [Sensor]
    let error: String?
}

struct Sensor: Decodable {
    let sensor_id: String
    let points: String
    let gateway_id: String
}
