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
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 1,y: 3)
            HStack{
                Text(title)
                    .font(.system(size: 20,weight: .heavy))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.leading,20)
        }
    }
}

struct FMNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        FMNavigationBarView(title: "test")
    }
}
