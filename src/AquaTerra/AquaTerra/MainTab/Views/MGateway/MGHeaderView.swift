//
//  FMHeaderView.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import SwiftUI

typealias ButtonActionBlock = () -> Void

struct MGHeaderView : View {
    
    @Binding var addGateways : Bool
    
    var body: some View{
        HStack{
            Text("NO.")
                .font(.custom("OpenSans-SemiBold", size: 16))
                .foregroundColor(.black)
            Spacer().frame(width: 35)
            Text("Gateway ID")
                .font(.custom("OpenSans-SemiBold", size: 16))
                .foregroundColor(.black)
            Spacer()
            Text("Add Gateway")
                .font(.custom("OpenSans-Bold", size: 14))
                .foregroundColor(.white)
                .onTapGesture {
                    addGateways = true
                }
                .frame(width: 126,height: 41)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#7FAF3A"), Color(hex: "#85B3A4")]),
                        startPoint: .topLeading,
                        endPoint:.bottomTrailing
                    ))
                .cornerRadius(5)
        }
        .padding(.vertical, 20)
        .padding(.trailing, 15)
        .padding(.leading, 33)
        .frame(maxWidth: .infinity)
        .onAppear{
            addGateways = false
        }
        .background(Color("bar"))
    }
}
