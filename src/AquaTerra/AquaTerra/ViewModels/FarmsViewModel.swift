//
//  FarmsViewModel.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

class FarmsViewModel: ObservableObject {
    
    let currentUserName: String

    var currentFarm: Farm?
    
    var farms: [Farm]?
    
    init(currentUserName: String) {
        self.currentUserName = currentUserName
    }
}
