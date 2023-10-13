//
//  Zone.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/9.
//

import Foundation

struct Zone: Codable, Hashable, Identifiable {
    /// zone id
    let id: UUID = UUID()
    /// user name
    var user: String
    /// farm name
    var farm: String
    /// zone name
    var name: String
    /// farm name
    var field: String
    
    var crop: String?
    
    var geom: String?
    
    var points: String
    var polyLineLocations: [[Double]] = []
    
    var soilType25: String?
    var soilType75: String?
    var soilType125: String?

    var wiltingPoint50: Int?
    var wiltingPoint100: Int?
    var wiltingPoint150: Int?

    var fieldCapacity50: Int?
    var fieldCapacity100: Int?
    var fieldCapacity150: Int?
    
    var saturation50: Int?
    var saturation100: Int?
    var saturation150: Int?
        
    var sensors: [String]?

    
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
}

struct ZoneEditable: Codable, Identifiable {
    /// zone id
    let id: UUID = UUID()
    /// user name
    var user: String = ""
    /// farm name
    var farm: String = ""
    /// zone name
    var name: String = ""
    /// farm name
    var field: String = ""
    
    var crop: String = ""
    
    var geom: String = ""
    
    var points: String = ""
    var polyLineLocations: [[Double]] = []
    
    var soilType25: String = ""
    var soilType75: String = ""
    var soilType125: String = ""

    var wiltingPoint50: String = ""
    var wiltingPoint100: String = ""
    var wiltingPoint150: String = ""

    var fieldCapacity50: String = ""
    var fieldCapacity100: String = ""
    var fieldCapacity150: String = ""
    
    var saturation50: String = ""
    var saturation100: String = ""
    var saturation150: String = ""
        
    var sensors: [String] = []

    
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
    
    static func copyFromZone(_ zone: Zone) -> ZoneEditable {
        return ZoneEditable(user: zone.user,
                    farm: zone.farm,
                    name: zone.name,
                    field: zone.field,
                    crop: zone.crop ?? "",
                    geom: zone.geom ?? "",
                    points: zone.points,
                    soilType25: zone.soilType25 ?? "",
                    soilType75: zone.soilType75 ?? "",
                    soilType125: zone.soilType125 ?? "",
                    wiltingPoint50: "\(zone.wiltingPoint50 ?? 0)",
                    wiltingPoint100: "\(zone.wiltingPoint100 ?? 0)",
                    wiltingPoint150: "\(zone.wiltingPoint150 ?? 0)",
                    fieldCapacity50: "\(zone.fieldCapacity50 ?? 0)",
                    fieldCapacity100: "\(zone.fieldCapacity100 ?? 0)",
                    fieldCapacity150: "\(zone.fieldCapacity150 ?? 0)",
                    saturation50: "\(zone.saturation50 ?? 0)",
                    saturation100: "\(zone.saturation100 ?? 0)",
                    saturation150: "\(zone.saturation150 ?? 0)",
                    sensors: zone.sensors ?? [])
    }
}
