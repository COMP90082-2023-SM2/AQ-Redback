//
//  ZoneGeometry.swift
//  AquaTerra
//
//  Created by WD on 2023/10/12.
//

import Foundation

struct ZoneGeometry: Codable {
    
    struct Geometry: Codable {
        
        let type: String
        let coordinates: [[Double]]
    }
    
    let type: String
    let geometry: Geometry
}
