//
//  ZoneDetailItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/11.
//

import SwiftUI

struct ZoneDetailItem: View {
    
    let title: String
    let subTitle: String
    let showRightArrow: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
                .padding(.vertical, 1)
            HStack {
                Text(title).font(.custom("OpenSans-Regular", size: 14))
                Spacer()
                Text(subTitle).font(.custom("OpenSans-Regular", size: 14))
                
                if showRightArrow {
                    Image("arrow_right").resizable().frame(width: 18, height: 18)
                }
            }
            .padding(.leading, 30)
            .padding(.trailing, 20)
        }
        .frame(height: 60)
    }
}

struct ZoneDetailItem_Previews: PreviewProvider {
    static var previews: some View {
        ZoneDetailItem(title: "Soil Type 25cmUnderground", subTitle: "Loadm", showRightArrow: true)
    }
}
