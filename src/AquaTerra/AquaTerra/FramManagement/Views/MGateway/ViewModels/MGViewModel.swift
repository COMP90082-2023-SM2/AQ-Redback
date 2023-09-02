//
//  MGViewModel.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import Foundation
import Combine

let baseUrl = "http://webapp.aquaterra.cloud"
let userName = "demo"

typealias RequestCompleteBlock = (_ error:Error?,_ data:[String:Any]?) -> Void
typealias RequestFinishBlock = () -> Void

class MGViewModel: ObservableObject {
    
    @Published var list : [MGInfoModel] = []
    
    static let shareInstance : MGViewModel = MGViewModel()
    static func share() -> MGViewModel {
        return shareInstance
    }
    
    private init(){}
    
    func fetchDatas(_ complete:RequestFinishBlock?) {
        guard let url = URL(string: baseUrl.appending("/api/gateway")) else { return }
        
        Task{
            await performRequest(url: url, method: "POST", body: setupData(data: nil)) { [weak self] error, data in
                var results : [MGInfoModel] = []
                var index = 1
                if let array = data?["data"] as? [[String:Any]] {
                    array.forEach { dict in
                        let m = MGInfoModel(no: "\(index)",gatewayId: dict["gateway_id"] as! String)
                        results.append(m)
                        index += 1
                    }
                }
                self?.list = results
                complete?()
            }
        }
    }
    
    func deleteItem(id:String,complete:RequestFinishBlock?){
        guard let url = URL(string: baseUrl.appending("/api/gateway/delete")) else { return }
        Task{
            await performRequest(url: url, method: "POST", body: setupData(data: ["gatewayId":id])) { [weak self] error, data in
                self?.fetchDatas(complete)
            }
        }
    }
    func submit(id:String,latitude:Double,longitude:Double) {
        guard let url = URL(string: baseUrl.appending("/api/gateway/new")) else { return }
        
        let geom : [String : Any] = [
            "type": "Feature",
            "geometry": [
                "type": "Polygon",
                "coordinates" : [
                    [latitude,longitude]
                ]
            ] as [String : Any]
        ]
        
        let body = setupData(data: [
            "gatewayId":id,
            "geom":geom
        ])
        
        Task{
            await performRequest(url: url, method: "POST", body: body, complete: { [weak self] error, data in
                self?.fetchDatas(nil)
            })
        }
    }
    
    private func performRequest(url:URL,method:String,body:[String:Any],complete:RequestCompleteBlock?) async {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: body) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let tast = URLSession.shared.dataTask(with: request) {data, response ,error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let data = data {
                    // To process the fetched data you can update the UI on the main thread
                    if let json = try? JSONSerialization.jsonObject(with: data) {
                        DispatchQueue.main.sync {
                            complete?(error,json as? [String : Any])
                        }
                    }
                }
            }
            
            tast.resume()
        }
    }
    
    private func setupData(data:[String:Any]?) -> [String:Any]{
        var dict : [String:Any] = ["userName":userName]
        if let data = data {
            dict.merge(data) { _, new in new}
        }
        return dict
    }
}

struct MGInfoModel : Hashable{
    var no : String = "1"
    var gatewayId : String = "2"
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.no)
    }
}
