//
//  FarmDeleteAlert.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/15.
//

import SwiftUI

struct FarmDeleteAlert: View {
    
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
                        GRButton(enable: $enable, title: "Delete", colors:[.init(hex: "984D4D")], buttonAction:{
                            deleteActionBlock?()
                        })
                        .frame(height: 40)
                        
                        Spacer().frame(width: 20)
                        
                        GRButton(enable: $enable, title: "Cancel") {
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

struct FarmDeleteAlert_Previews: PreviewProvider {
    
    @State static var showup = true
    
    static var previews: some View {
        FarmDeleteAlert(title: "Farm Deletion", content: "Are you sure you want to delete this farm ?", showup: $showup)
    }
}
