//
//  ZoneInfoEditItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/12.
//

import SwiftUI

struct ZoneInfoEditItem: View {
    
    let title: String
    
    let placeholder: String
    
    @Binding var subTitle: String
    
    let disabled: Bool
    
    let showRightArrow: Bool
    
    @State var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
                .padding(.vertical, 1)
            HStack {
                Text(title).font(.custom("OpenSans-Regular", size: 14))
                Spacer()
                TextField(placeholder,text: $subTitle)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("Placeholder"))
                    .accentColor(Color("ButtonGradient2"))
                    .keyboardType(keyboardType)
                    .disabled(disabled)
                    
                if showRightArrow {
                    Image("arrow_right").resizable().frame(width: 18, height: 18)
                }
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
        .frame(height: 60)
    }
}

struct ZoneInfoEditItem_Previews: PreviewProvider {
    
    static var subTitle : Binding<String> {
        Binding<String>(
            get: {
                return ""
            },
            set: { _ in }
        )
    }
    
    static var previews: some View {
        ZoneInfoEditItem(title: "Crop Type", placeholder: "Crop", subTitle: subTitle, disabled: false, showRightArrow: false)
    }
}
