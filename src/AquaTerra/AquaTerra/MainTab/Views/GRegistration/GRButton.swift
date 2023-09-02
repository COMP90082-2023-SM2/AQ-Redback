//
//  GRButton.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct GRButton: View {
    @Binding var enable : Bool
    var title : String = "title"
    var font : Font?
    var colors : [Color] = [.init(hex: "#7FAF3A"),.init(hex: "#85B3A4")]
    var buttonAction : ButtonActionBlock?
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                if !enable { return }
                buttonAction?()
            } label: {
                Text(title)
                    .font(font)
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width,height: geometry.size.height)
                    .cornerRadius(5)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint:.bottomTrailing
                )
                .cornerRadius(5)
                .opacity(enable ? 1 : 0.3)
            )
        }
    }
}

struct GRButton_Previews: PreviewProvider {
    @State static var c = true
    
    static var previews: some View {
        GRButton(enable: $c)
            .frame(width: 200,height: 50)
    }
}
