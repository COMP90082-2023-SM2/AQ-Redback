//
//  CustomTabBar.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case manage = 1
    case profile = 2
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .frame(width: 355, height: 90)
                .shadow(color: Color.black.opacity(0.10), radius: 10.0, x: 1, y: 4.0)
            
            HStack(alignment:.center){
                Button{
                    selectedTab = .home
                    //Switch to Home
                }label: {
                    GeometryReader{
                        geo in
                        if selectedTab == .home {
                            VStack(alignment: .center, spacing: 5){
                                Image("Home")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                    .foregroundColor(Color("ButtonGradient2"))
                                Text("Dashboard")
                                    .font(.custom("OpenSans-SemiBold", size: 12))
                            }.foregroundColor(Color("ButtonGradient2"))
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                Image("Home")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                Text("Dashboard")
                                    .font(.custom("OpenSans-Regular", size: 12))
                            }.foregroundColor(Color.black)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
                
                Button{
                    selectedTab = .manage
                    //Switch to manage
                }label: {
                    GeometryReader{
                        geo in
                        if selectedTab == .manage {
                            VStack(alignment: .center, spacing: 5){
                                Image(systemName: "tree.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                Text("Manage")
                                    .font(.custom("OpenSans-SemiBold", size: 12))
                            }.foregroundColor(Color("ButtonGradient2"))
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                Image(systemName: "tree.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                Text("Manage")
                                    .font(.custom("OpenSans-Regular", size: 12))
                            }.foregroundColor(Color.black)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
                
                Button{
                    selectedTab = .profile
                    //Switch to Home
                }label: {
                    GeometryReader{
                        geo in
                        if selectedTab == .profile {
                            VStack(alignment: .center, spacing: 5){
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                Text("Profile")
                                    .font(.custom("OpenSans-SemiBold", size: 12))
                            }.foregroundColor(Color("ButtonGradient2"))
                                 .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:24, height: 24)
                                Text("Profile")
                                    .font(.custom("OpenSans-Regular", size: 12))
                            }.foregroundColor(Color.black)
                                 .frame(width: geo.size.width, height: geo.size.height)
                            
                        }
                    }
                }
                
            }.frame(width: 335, height: 90)
                
            
            
        }
        
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.manage))
    }
}
