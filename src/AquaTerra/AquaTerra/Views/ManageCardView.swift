//
//  ManageCardView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 15/9/2023.
//

import SwiftUI
// This style setting for the card view
struct ManageCardView: View {
    var imgName : String
    var TextName: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 318, height: 110)

            Image(imgName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 318, height: 110)
                .cornerRadius(10)
                
        
            Text(TextName)
                .font(.custom("OpenSans-ExtraBold", size: 20))
                .foregroundColor(Color.white)
        }.frame(width: 318, height: 110)
    }
}

