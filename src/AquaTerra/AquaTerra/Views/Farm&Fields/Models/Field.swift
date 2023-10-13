//
//  Field.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import Foundation

struct Field: Codable, Hashable, Identifiable {
    /// field id
    let id: String
    /// user name
    let user: String
    /// field name
    var name: String
    /// farm name
    let farm: String
    
    let crop: String?
    
    let soil: String?
    
    let geom: String
    
    let points: String

    let elevation: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "field_id"
        case user = "username"
        case name = "field_name"
        case farm = "farm_name"
        case crop = "crop_type"
        case soil = "soil_type"
        case geom, points, elevation
    }
}
