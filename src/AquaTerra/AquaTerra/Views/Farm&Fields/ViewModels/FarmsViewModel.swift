//
//  FarmsViewModel.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import SwiftUI

class FarmsViewModel: ObservableObject {
    
    let currentUserName: String

    var currentFarm: Farm?
    
    var farms: [Farm]?
    
    init(currentUserName: String, currentFarm: Farm? = nil, farms: [Farm]? = nil) {
        self.currentUserName = currentUserName
        self.currentFarm = currentFarm
        self.farms = farms
    }
    
    static func previewViewModel() -> FarmsViewModel {
        
        let fields1 = [Field(id: UUID().uuidString, user: "Demo", name: "Field1", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Field2", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Morningt....", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)]
        
        let farms = [Farm(id: UUID().uuidString, user: "Demo", name: "Farm1", fields: fields1),
                     Farm(id: UUID().uuidString, user: "Demo", name: "Farm2")]
        
        let viewmodel = FarmsViewModel(currentUserName: "Demo", currentFarm: farms.first!, farms: farms)
        
        return viewmodel
    }
}
