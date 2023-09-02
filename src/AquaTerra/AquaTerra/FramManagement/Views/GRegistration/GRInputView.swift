//
//  GRInputView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct GRInputView: View {
    var buttonClick : ButtonActionBlock?
    @Binding var textFiledText : String
    @Binding var enable : Bool
    
    var body: some View {
        VStack(alignment:.leading){
            HStack(){
                Text("Pleas Enter your")
                    .font(.system(size: 16))
                Text("gateway ID:")
                    .font(.system(size: 16,weight: .bold))
            }
            HStack{
                Text("Note: The gateway ID is provided with your purchase.")
                    .font(.system(size: 13))
            }
            .padding(.top,1)
            TextField("Example:AquaTerraGateway909a56",text: $textFiledText)
                .frame(height: 50)
                .textFieldStyle(
                    TextFieldFillStyle(backColor: .init(hex: "D8D8D8")
                        .opacity(0.3))
                )
                .font(.system(size: 14,weight: .bold))
                .padding(.top)
            GRButton(enable: $enable,title: "Next",buttonAction: {
                buttonClick?()
            })
                .frame(height: 50)
                .padding(.top)
        }
    }
}

struct GRInputView_Previews: PreviewProvider {
    @State static var text = ""
    
    static var isTextEmpty : Binding<Bool> {
        Binding<Bool>(
            get: {
                return !text.isEmpty
            },
            set: { _ in }
        )
    }
    
    static var previews: some View {
        GRInputView(textFiledText: $text, enable: isTextEmpty)
    }
}
