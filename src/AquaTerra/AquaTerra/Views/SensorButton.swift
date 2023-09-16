//
//  SensorButton.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI

struct SensorButton: View {
    var title : String = "title"
    var font : Font?
    var colors : [Color] = [.init(hex: "#7FAF3A"),.init(hex: "#85B3A4")]
    var buttonAction : ButtonActionBlock?
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                buttonAction?()
            } label: {
                Text(title)
                    .font(.custom("OpenSans-SemiBold", size: 14))
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
                .opacity(1)
            )
        }
    }
}
