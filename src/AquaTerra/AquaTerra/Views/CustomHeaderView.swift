//
//  CustomHeaderView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI

struct CustomHeaderView: View {
    var title : String
    
    
    var body: some View {
        
        VStack(spacing: 24) {
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(maxHeight: 127)
                    .shadow(color: Color.black.opacity(0.15), radius: 2.0, x: 0, y: 0)
                Text(title)
                    .font(.custom("OpenSans-ExtraBold", size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 76)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
            }.ignoresSafeArea()
                .frame(height: 65)
        }
    }
}

struct CustomHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomHeaderView(title:"test")
    }
}
