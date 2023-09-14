//
//  Farm.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import Foundation

struct Farm: Identifiable {
    /// field id
    let id: String
    /// user name
    let user: String
    /// field name
    var name: String
    
    var fields: [Field]?
}
