//
//  TabbarView.swift
//  Gateways
//
//  Created by ... on 2023/9/10.
//

import SwiftUI

struct CusTabbarView: View {
    @Binding var selected : Int
    var items : [String]
    var body: some View {
        HStack{
            ForEach(0..<items.count,id: \.self){index in
                let color = selected == index ? .init(hex: "#C1B18B") : Color.black
                Spacer()
                Image(items[index])
                    .renderingMode(.template)
                    .foregroundColor(color)
                    .onTapGesture {
                        selected = index
                    }
                Spacer()
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    @State static var select = 1
    static var previews: some View {
        CusTabbarView(selected: $select,items: ["tabbar_1","tabbar_2","tabbar_3"])
    }
}
