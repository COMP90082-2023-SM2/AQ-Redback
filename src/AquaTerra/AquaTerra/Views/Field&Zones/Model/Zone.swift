//
//  Zone.swift
//  AquaTerra
//
//  Created by WD on 2023/10/9.
//

import Foundation

struct Zone: Codable, Hashable, Identifiable {
    /// zone id
    let id: UUID = UUID()
    /// user name
    let user: String
    /// zone name
    var name: String
    /// farm name
    let farm: String
    /// farm name
    let field: String
    
    let crop: String?
    
    let geom: String?
    
    var points: String
    var polyLineLocations: [[Double]] = []
    
    let soilType25: String?
    let soilType75: String?
    let soilType125: String?

    let wiltingPoint50: Int?
    let wiltingPoint100: Int?
    let wiltingPoint150: Int?

    let fieldCapacity50: Int?
    let fieldCapacity100: Int?
    let fieldCapacity150: Int?
    
    let saturation50: Int?
    let saturation100: Int?
    let saturation150: Int?
        
    let sensors: [String]?

    
    enum CodingKeys: String, CodingKey {

        case geom, points, sensors

        case user = "username"
        case name = "zonename"
        case farm = "farmname"
        case field = "fieldname"
        case crop = "croptype"

        case soilType25 = "soiltype_25"
        case soilType75 = "soiltype_75"
        case soilType125 = "soiltype_125"
        
        case wiltingPoint50 = "wpoint_50"
        case wiltingPoint100 = "wpoint_100"
        case wiltingPoint150 = "wpoint_150"

        case fieldCapacity50 = "fcapacity_50"
        case fieldCapacity100 = "fcapacity_100"
        case fieldCapacity150 = "fcapacity_150"
        
        case saturation50 = "saturation_50"
        case saturation100 = "saturation_100"
        case saturation150 = "saturation_150"
    }
    
    func copyZone() -> Zone {
        return Zone(user: self.user,
                    name: self.name,
                    farm: self.farm,
                    field: self.field,
                    crop: self.crop,
                    geom: self.geom,
                    points: self.points,
                    soilType25: self.soilType25,
                    soilType75: self.soilType75,
                    soilType125: self.soilType125,
                    wiltingPoint50: self.wiltingPoint50,
                    wiltingPoint100: self.wiltingPoint100,
                    wiltingPoint150: self.wiltingPoint150,
                    fieldCapacity50: self.fieldCapacity50,
                    fieldCapacity100: self.fieldCapacity100,
                    fieldCapacity150: self.fieldCapacity150,
                    saturation50: self.saturation50,
                    saturation100: self.saturation100,
                    saturation150: self.saturation150,
                    sensors: self.sensors)
    }
}
