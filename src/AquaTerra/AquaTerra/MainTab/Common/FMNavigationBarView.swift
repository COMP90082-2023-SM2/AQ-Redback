//
//  FMNavigationBarView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct FMNavigationBarView: View {
    var title : String
    
    var body: some View {
        ZStack{
            
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(maxHeight: 150)
//                    .shadow(color: Color.black.opacity(0.15), radius: 2.0, x: 0, y: 0)
                    .ignoresSafeArea()
                
                
                Text(title)
                    .font(.custom("OpenSans-ExtraBold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 95)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 10)
            }.ignoresSafeArea()
                .frame(maxHeight: 127)
            
        }
    }
}

struct FMNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        FMNavigationBarView(title: "test")
    }
}
