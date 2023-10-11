//
//  FarmNetwork.swift
//  AquaTerra
//
//  Created by Joyce on 2023/9/15.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    
    func methodString() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidParmas
    case requestFailed
    case invalidData
    case decodingFailed
}

class FarmNetwork {
    
    static let shared = FarmNetwork()
    
    let host = "https://webapp.aquaterra.cloud"

    //MARK: API - Fetch Farms
    func fetchFarms(for user: String) async throws -> [Farm]? {
        
        guard let url = URL(string: host.appending("/api/farm")) else {
            throw NetworkError.invalidURL
        }
        
        let body: [String:Any] = ["userName": user]
        
        let data = try await performRequest(url: url, method: .post, body: body)
        
        guard let payload = data?["data"] as? [[String: AnyObject]] else {
            throw NetworkError.invalidData
        }
        
        return try JSONDecoder().decode([Farm].self, from: JSONSerialization.data(withJSONObject: payload))
    }
    
    //MARK: API - Fetch Fields
    func fetchFields(for user: String) async throws -> [Field]? {
        
        guard let url = URL(string: host.appending("/api/field")) else {
            throw NetworkError.invalidURL
        }
        
        let body: [String:Any] = ["userName": user]
        
        let data = try await performRequest(url: url, method: .post, body: body)
        
        guard let payload = data?["data"] as? [[String: AnyObject]] else {
            throw NetworkError.invalidData
        }
                
        do {
            let fields = try JSONDecoder().decode([Field].self, from: JSONSerialization.data(withJSONObject: payload))
            return fields
            
        } catch {
            print(error)
            throw NetworkError.invalidData
        }
    }
    
    //MARK: API - Register Farm
    func registerFarm(for user: String, newFarm: NewFarm) async throws {
        
        guard let url = URL(string: host.appending("/api/farm/addFarm")) else {
            throw NetworkError.invalidURL
        }
        
        let geom : [String : Any] = [
            "type": "Feature",
            "geometry": [
                "type": "Polygon",
                "coordinates" : [newFarm.polyLineLocations]
            ] as [String : Any]
        ]
        
        let body: [String:Any] = ["userName": user,
                                   "farmName": newFarm.name,
                                   "geom": geom]
        
        _ = try await performRequest(url: url, method: .post, body: body)
    }
    
    //MARK: API - Add Field
    func registerField(for user: String, in newFarm: NewFarm) async throws {
        
        guard let url = URL(string: host.appending("/api/field/addField")) else {
            throw NetworkError.invalidURL
        }
            
        let geom : [String : Any] = [
            "type": "Feature",
            "geometry": [
                "type": "Polygon",
                "coordinates" : [newFarm.polyLineLocations]
            ] as [String : Any],
            "properties": [:]
        ]
        
        let body: [String:Any] = ["userName": user,
                                   "fieldName": newFarm.fieldName,
                                   "farmName": newFarm.name,
                                   "geom": geom]
        
        _ = try await performRequest(url: url, method: .post, body: body)
    }
    
    //MARK: API - Delete Field
    func deleteField(_ fieldID: String) async throws {
        
        guard let url = URL(string: host.appending("/api/field/\(fieldID)")) else {
            throw NetworkError.invalidURL
        }
        
        _ = try await performRequest(url: url, method: .delete, body: nil)
    }

    //MARK: API - Delete Farm
    func deleteFarm(for user: String, farm: String) async throws {
        
        let path = host.appending("/api/farm/\(user)/\(farm)")
       
        guard let encodedString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        guard let url = URL(string: encodedString) else {
            throw NetworkError.invalidURL
        }
        
        _ = try await performRequest(url: url, method: .delete, body: nil)
    }
    
    //MARK: API - Fetch Zones
    func fetchZones(for user: String) async throws -> [Zone]? {
        
        guard let url = URL(string: host.appending("/api/zone")) else {
            throw NetworkError.invalidURL
        }
        
        let body: [String: Any] = ["userName": user]
        
        let data = try await performRequest(url: url, method: .post, body: body)
        
        guard let payload = data?["data"] as? [[String: AnyObject]] else {
            throw NetworkError.invalidData
        }
                
        do {
            let zones = try JSONDecoder().decode([Zone].self, from: JSONSerialization.data(withJSONObject: payload))
            return zones
            
        } catch {
            print(error)
            throw NetworkError.invalidData
        }
    }
    
    //MARK: API - Add Zone
    func registerZone(zone: Zone, for user: String) async throws {
        
        guard let url = URL(string: host.appending("/api/zone/addZone")) else {
            throw NetworkError.invalidURL
        }
            
        let geom : [String : Any] = [
            "type": "Feature",
            "geometry": [
                "type": "Polygon",
                "coordinates" : [zone.polyLineLocations]
            ] as [String : Any],
            "properties": [:]
        ]
        
        var body: [String:Any] = ["userName": user,
                                  "zoneName": zone.name,
                                  "fieldName": zone.field,
                                  "geom": geom,
        ]
        body["farmName"] = zone.farm
        body["cropType"] = zone.crop
        
        body["soilType25"] = zone.soilType25
        body["soilType75"] = zone.soilType75
        body["soilType125"] = zone.soilType125
        
        body["wPoint50"] = zone.wiltingPoint50
        body["wPoint100"] = zone.wiltingPoint100
        body["wPoint150"] = zone.wiltingPoint150

        body["fCapacity50"] = zone.fieldCapacity50
        body["fCapacity100"] = zone.fieldCapacity100
        body["fCapacity150"] = zone.fieldCapacity150

        body["saturation50"] = zone.saturation50
        body["saturation100"] = zone.saturation100
        body["saturation150"] = zone.saturation150

        _ = try await performRequest(url: url, method: .post, body: body)
    }
    
    //MARK: API - Delete Field
    func deleteZone(_ zone: Zone, for user: String) async throws {
        
        let path = host.appending("/api/zone/deleteZone")
       
        guard let encodedString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        guard let url = URL(string: encodedString) else {
            throw NetworkError.invalidURL
        }
        
        let body: [String: Any] = ["userName": user,
                                  "fieldName": zone.field,
                                   "zoneName": zone.name
        ]
        
        _ = try await performRequest(url: url, method: .delete, body: body)
    }
    
    //MARK: Private HTTP Request
    private func performRequest(url: URL, method: HTTPMethod, body: [String:Any]?) async throws -> [String : Any]? {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.methodString()
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
            } catch {
                throw NetworkError.invalidParmas
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            
            return json as? [String: Any]
            
        } catch {
            throw NetworkError.invalidData
        }
    }
}
