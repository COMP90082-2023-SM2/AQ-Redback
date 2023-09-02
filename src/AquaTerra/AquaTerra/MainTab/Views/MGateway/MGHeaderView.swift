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
            Text("No.")
                .font(.system(size: 16,weight: .bold))
                .foregroundColor(.black)
            Spacer().frame(width: 30)
            Text("Gateway ID")
                .font(.system(size: 16,weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Text("Add Gateway")
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
        .foregroundColor(.init(hex: "#FAFAFA"))
        .frame(height: 60)
        .onAppear{
            addGateways = false
        }
    }
}
