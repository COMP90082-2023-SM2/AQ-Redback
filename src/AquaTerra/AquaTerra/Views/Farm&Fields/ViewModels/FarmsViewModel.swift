//
//  FarmsViewModel.swift
//  AquaTerra
//
//  Created by Joyce on 2023/9/13.
//

import SwiftUI

class FarmsViewModel: ObservableObject {
    
    let currentUserName: String

    @AppStorage("CurrentFarm") var currentFarmName: String = ""

    @Published var currentFarm: Farm?
    
    @Published var farms: [Farm]?
    
    @Published var fields: [Field]?

    ///for add a new farm
    @Published var newFarm: NewFarm = NewFarm(user: "", name: "", fieldName: "")

    typealias FarmRequestCompleteBlock = (_ error: Error?, _ data: Data?) -> Void

    init(currentUserName: String, currentFarm: Farm? = nil, farms: [Farm]? = nil, fields: [Field]? = nil) {
        self.currentUserName = currentUserName
        self.currentFarm = currentFarm
        self.farms = farms
    }
    
    @MainActor
    func fetchFarmsAndFieldsData() {
        
        Task {
            
            farms = try await FarmNetwork.shared.fetchFarms(for: currentUserName)
            
            currentFarm = farms?.filter({$0.name.elementsEqual(currentFarmName)}).first
            
            if currentFarm == nil {
                currentFarmName = "" //update local current selected farm if remote delete
            }
            
            fields = try await FarmNetwork.shared.fetchFields(for: currentUserName)
        }
    }
    
    @MainActor
    func fetchFieldsData() {
        
        Task {
            fields = try await FarmNetwork.shared.fetchFields(for: currentUserName)
        }
    }
    
    //MARK: API - Add Field
    @MainActor
    func registerField() {
        
        let exist = farms?.filter({$0.name.elementsEqual(newFarm.name)}).first
        print(exist ?? "farm not exsit, should register farm: \(newFarm.name)")
        if exist == nil {
            
            Task {
                try await FarmNetwork.shared.registerFarm(for: currentUserName, newFarm: newFarm)
                try await FarmNetwork.shared.registerField(for: currentUserName, in: newFarm)
                
                //reset after success
                newFarm = NewFarm(user: "", name: "", fieldName: "")
                
                fetchFarmsAndFieldsData()
            }
            
        } else {
            Task {
                try await FarmNetwork.shared.registerField(for: currentUserName, in: newFarm)
                
                //reset after success
                newFarm = NewFarm(user: "", name: "", fieldName: "")
                
                fetchFarmsAndFieldsData()
            }
        }
    }
    
    //MARK: API - Delete Field
    @MainActor
    func deleteField(field: Field) {
       Task {
            try await FarmNetwork.shared.deleteField(field.id)
            
            await fetchFieldsData()
        }
    }

    //MARK: API - Delete Farm
    func deleteFarm(farm: Farm) {
        
        Task {
            try await FarmNetwork.shared.deleteFarm(for: currentUserName, farm: farm.name)
            
            await fetchFarmsAndFieldsData()
        }
    }
    
    //MARK: Preview
    static func previewViewModel() -> FarmsViewModel {
        
        let farms = [Farm(user: "Demo", name: "Farm1"),
                     Farm(user: "Demo", name: "Farm2")]
        
        let fields = [Field(id: UUID().uuidString, user: "Demo", name: "Field1", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Field2", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                       Field(id: UUID().uuidString, user: "Demo", name: "Morningt....", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)]
        let viewmodel = FarmsViewModel(currentUserName: "Demo", currentFarm: farms.first!, farms: farms, fields: fields)

        return viewmodel
    }
}
