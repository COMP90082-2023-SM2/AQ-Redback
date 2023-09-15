//
//  TabBarItem.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 15/9/2023.
//

import SwiftUI

struct TabBarItemIcon: View {
    var imgName : String
    var isActive: Bool
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        GeometryReader{
            geo in
            if isActive{
                VStack(alignment: .center, spacing: 5){
                    Image(imgName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .foregroundColor(Color("HighlightColor"))

                }.foregroundColor(Color("HighlightColor"))
                    .frame(width: geo.size.width, height: geo.size.height)

            }else{
                VStack(alignment: .center, spacing: 5){
                        Image(imgName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width:width, height: height)
                }.foregroundColor(Color.black)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

//struct TabBarItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarItem()
//    }
//}
