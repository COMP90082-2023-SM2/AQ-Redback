//
//  FieldViewModel.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/9.
//

import SwiftUI

enum ZoneNavigationDestination: String {
    case zoneList
    case zoneDetail
    case zoneModify
    case zoneRegister
}

class FieldViewModel: ObservableObject {
    
    static let shared = FieldViewModel()
    
    var currentUserName: String = ""

    @Published var currentField: Field?
    @AppStorage("CurrentField") var currentFieldName: String = ""

    @Published var fields: [Field]?

    @Published var zones: [Zone]?

    @Published var farms: [Farm]?

    ///for edit a zone
    @Published var editZone: ZoneEditable = ZoneEditable()
    @Published var editZoneOldName: String = ""

    ///for add a new zone
    @Published var newZone: ZoneEditable = ZoneEditable()
    
    @MainActor
    func fetchFieldsAndZonesData() {
        
        Task {
            
            farms = try await FarmNetwork.shared.fetchFarms(for: currentUserName)

            fields = try await FarmNetwork.shared.fetchFields(for: currentUserName)

            currentField = fields?.filter({$0.name.elementsEqual(currentFieldName)}).first
            
            if currentField == nil {
                currentFieldName = "" //update local current selected farm if remote delete
            }
            
            zones = try await FarmNetwork.shared.fetchZones(for: currentUserName)
        }
    }
    
    //MARK: API - Fetch Zones
    @MainActor
    func fetchZonesData() {
        
        Task {
            zones = try await FarmNetwork.shared.fetchZones(for: currentUserName)
        }
    }
    
    //MARK: API - Add Zone
    @MainActor
    func addZone(_ newZone: ZoneEditable) {

        Task {
            try await FarmNetwork.shared.registerOrEditZone(zone: newZone, for: currentUserName)
            
            self.newZone = ZoneEditable()
            
            fetchFieldsAndZonesData()
        }
    }
    
    //MARK: API - Edit Zone
    @MainActor
    func editZone(_ zone: ZoneEditable, oldZoneName: String) {
        
        Task {
            try await FarmNetwork.shared.registerOrEditZone(zone: zone, editingZoneName: oldZoneName, for: currentUserName)

            self.editZone = ZoneEditable()
            self.editZoneOldName = ""
            
            fetchFieldsAndZonesData()
        }
    }
    
    //MARK: API - Delete Field
    @MainActor
    func deleteZone(zone: Zone, for user: String) {
       Task {
            try await FarmNetwork.shared.deleteZone(zone, for: user)
            
            fetchZonesData()
        }
    }
    
    //MARK: Preview
    static func previewViewModel() -> FieldViewModel {
        
        let fields = [Field(id: UUID().uuidString, user: "Demo", name: "Field1", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Field2", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Morningt....", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)]
        
        let currentField: Field = fields.first!
        
        let zones = [Zone(user: "Demo", farm: "Farm1", name: "TestZone1", field: currentField.name, crop: "Rice", geom: nil, points: "", soilType25: "Loam", soilType75: "Loam", soilType125: "Loam", wiltingPoint50: 7, wiltingPoint100: 7, wiltingPoint150: 7, fieldCapacity50: 20, fieldCapacity100: 20, fieldCapacity150: 20, saturation50: 30, saturation100: 30, saturation150: 30, sensors: nil),
                     Zone(user: "Demo", farm: "Farm1", name: "TestZone2", field: currentField.name, crop: "Rice", geom: nil, points: "", soilType25: "Loam", soilType75: "Loam", soilType125: "Loam", wiltingPoint50: 7, wiltingPoint100: 7, wiltingPoint150: 7, fieldCapacity50: 20, fieldCapacity100: 20, fieldCapacity150: 20, saturation50: 30, saturation100: 30, saturation150: 30, sensors: nil)]
        
        let viewmodel = FieldViewModel.shared
        viewmodel.currentField = currentField
        viewmodel.currentFieldName = currentField.name
        viewmodel.fields = fields
        viewmodel.zones = zones

        return viewmodel
    }
}


extension Array where Element: Equatable {
    
    func removeDuplicate() -> Array {
       return self.enumerated().filter { (index,value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
            value
        }
    }
}
