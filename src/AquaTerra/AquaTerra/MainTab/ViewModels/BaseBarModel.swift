//
//  FMBarModel.swift
//  Gateways
//
//  Created by ... on 2023/9/10.
//

import Foundation

class BaseBarModel : ObservableObject {
    
    @Published var showTab : Bool = true
    
    static var share : BaseBarModel = BaseBarModel()
    
    private init(){
        showTab = true
    }
    
    func hidden(){
        showTab = false
    }
    
    func show(){
        showTab = true
    }
}
