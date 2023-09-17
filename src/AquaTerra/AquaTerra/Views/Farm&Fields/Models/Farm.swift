//
//  Farm.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import Foundation

struct Farm: Codable, Identifiable {
    /// field id
    let id: String = UUID().uuidString
    /// user name
    let user: String
    /// farm name
    var name: String
        
    enum CodingKeys: String, CodingKey {
        case name = "farm_name"
        case user = "username"
    }
}

struct NewFarm: Identifiable {
    /// field id
    let id: String = UUID().uuidString
    /// user name
    let user: String
    /// farm name
    var name: String
    
    var fieldName: String
    
    //TODO: confirm api data struct
    var polyLineLocations: [[Double]] = []
}
