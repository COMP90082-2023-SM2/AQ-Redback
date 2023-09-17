//
//  FarmNetwork.swift
//  AquaTerra
//
//  Created by wd on 2023/9/15.
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
