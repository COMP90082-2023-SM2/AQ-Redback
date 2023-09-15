//
//  Extension.swift
//  AquaTerra
//
//  Created by Davincci on 15/9/2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
