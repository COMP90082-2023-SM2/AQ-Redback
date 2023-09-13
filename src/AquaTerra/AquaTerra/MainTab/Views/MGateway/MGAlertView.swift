//
//  MGAlertView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct MGAlertView: View {
    @State private var enable = true
    @Binding var showup : Bool
    var id : String
    
    var deleteActionBlock : DeleteActionBlock?
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                VStack{
                    HStack {
                        Text("Gateway Deletion")
                            .font(.custom("OpenSans-Bold", size: 14))
                        Spacer()
                        Image("close-fill")
                            .onTapGesture {
                                showup = false
                            }
                    }
                    .padding(20)
                    Text("All sensors connected to this gateway will be deleted. Are you sure?")
                        .font(.custom("OpenSans-Regular", size: 14))
                        .padding(.top,-5)
                        .padding(.leading,20)
                        .padding(.trailing,20)
                    HStack{
                        GRButton(enable: $enable,title: "Delete",colors:[.init(hex: "984D4D")], buttonAction:{
                            deleteActionBlock?(id)
                        })
                        Spacer().frame(width: 20)
                        GRButton(enable: $enable,title: "Cancel") {
                            withAnimation(.easeIn,{
                                showup = false
                            })
                        }
                    }
                    .padding()
                }
                .frame(width: 258,height: 211)
                .background(.white)
                .cornerRadius(8)
            }
            .frame(width: geometry.size.width,height: geometry.size.height)
            .background(.black.opacity(0.3))
        }
    }
}

struct MGAlertView_Previews: PreviewProvider {
    @State static var showup = true
    static var previews: some View {
        MGAlertView(showup: $showup,id: "123456")
    }
}
