//
//  ZoneGeometry.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/12.
//

import Foundation

struct ZoneCoordinates: Codable {
    
    let type: String
    //FIXME: Invalid multiple empty array in api data
    let coordinates: [[[Double]]]
}
