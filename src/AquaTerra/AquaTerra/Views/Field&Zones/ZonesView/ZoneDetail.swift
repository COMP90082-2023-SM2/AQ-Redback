//
//  ZoneDetail.swift
//  AquaTerra
//
//  Created by WD on 2023/10/11.
//

import SwiftUI

struct ZoneDetail: View {
    
    let index: Int

    var body: some View {
        Text("Hello, World \(index)")
    }
}

struct ZoneDetail_Previews: PreviewProvider {
    static var previews: some View {
        ZoneDetail(index: 0)
    }
}
