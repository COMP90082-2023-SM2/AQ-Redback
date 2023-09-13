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
            HStack(spacing: 3.5){
                Text("Please enter your")
                    .font(.custom("OpenSans-Regular", size: 16))
                Text("Gateway ID:")
                    .font(.custom("OpenSans-Bold", size: 16))
            }
            HStack{
                Text("Note: The gateway ID is provided with your purchase.")
                    .font(.custom("OpenSans-Regular", size: 13))
            }
            .padding(.top,1)
            
            VStack(alignment: .center){
                TextField("Example:AquaTerraGateway909a56",text: $textFiledText)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("Placeholder"))
                    .padding([.horizontal], 15)
                    .frame(height: 50)
                    .accentColor(Color("ButtonGradient2"))
                
            }
            .background(Color("Hint"))
            .cornerRadius(5)
            
            
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
