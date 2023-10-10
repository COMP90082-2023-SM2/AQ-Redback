//
//  ProfileItemView.swift
//  AquaTerra
//
//  Created by OLI L on 2023/10/10.
//

import SwiftUI

struct ProfileItemView: View {
    var profileTitle: String
    var profileDetail: String
 
    var body: some View {
        
        HStack {
            Text(profileTitle)
                .font(.custom("OpenSans-SemiBold", size: 16))

            Spacer()
            Spacer()
            
            Text(profileDetail)
                .font(.custom("OpenSans-Regular", size: 16)).padding(.leading, 30)
            
        
        }
        .frame(height: 68)
        .padding(.horizontal, 10)
    }
    
    struct ProfileItemView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileItemView(profileTitle: "username", profileDetail: "demo")
        }
    }
    
}
