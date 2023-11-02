//
//  ProfileItemView.swift
//  AquaTerra
//
//  Created by OLI L on 2023/10/10.
//

import SwiftUI
// This is profile item view 
struct ProfileItemView: View {
    var profileTitle: String
    var profileDetail: String
 
    var body: some View {
        VStack{
            ZStack{
                HStack {
                    Text(profileTitle)
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .padding(.leading, 20)

                    Spacer()
                    Spacer()
                    
                    Text(profileDetail)
                        .font(.custom("OpenSans-Regular", size: 16))
                        .padding(.trailing, 20)
                    
                
                }
                VStack{
                    Spacer()
                    Divider()
                }
            }.frame(height: 68)

        }.frame(maxWidth: .infinity)
            .frame(height: 68)
    }
    
    struct ProfileItemView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileItemView(profileTitle: "username", profileDetail: "demo")
        }
    }
    
}
