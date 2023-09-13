//
//  Field.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import Foundation

struct Field {
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

    let elevation: String?
}
