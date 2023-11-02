//
//  SignUpAlertView.swift
//  AquaTerra
//
//  Created by OLI L on 2023/10/11.
//

import SwiftUI
// This is sign up alert view
struct SignUpAlertView: View {
    
    let title: String
    
    let content: String
    
    @State private var enable = true
    
    @Binding var showup : Bool
    
    var deleteActionBlock: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    HStack {
                        Text(title)
                            .font(.custom("OpenSans-Bold", size: 14))
                        Spacer()
                        Image("close-fill")
                            .onTapGesture {
                                showup = false
                            }
                    }
                    .padding(20)
                    
                    Text(content)
                        .font(.custom("OpenSans-Regular", size: 14))
                        .padding(.top,-5)
                        .padding(.leading,20)
                        .padding(.trailing,20)
                    
                    HStack {
                        
                        GRButton(enable: $enable, title: "OK") {
                            withAnimation(.easeIn,{
                                showup = false
                            })
                        }
                        .frame(height: 40)
                    }
                    .padding()
                }
                .frame(width: 258, height: 211)
                .background(.white)
                .cornerRadius(20)
            }
            .frame(width: geometry.size.width,height: geometry.size.height)
            .background(.black.opacity(0.3))
        }
    }
}

struct SignUpAlertView_Previews: PreviewProvider {
    
    @State static var showup = true
    
    static var previews: some View {
        SignUpAlertView(title: "Sign Up Unavaliable", content: "Please visit Aquaterra Official Website ", showup: $showup)
    }
}
