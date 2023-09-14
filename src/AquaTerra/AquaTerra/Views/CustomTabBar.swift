//
//  CustomTabBar.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI
import Amplify

enum Tabs: Int {
    case home = 0
    case manage = 1
    case profile = 2
}

struct CustomTabBar: View {
    
    
    @Binding var selectedTab: Tabs
    @Binding var user: AuthUser
    
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel

    @ObservedObject private var viewModel = SessionViewViewModel()
    
    @State private var showDashboardView = false
    @State private var showSessionView = false
    @State private var showProfileView = false
    

    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .frame(width: 355, height: 90)
                .shadow(color: Color.black.opacity(0.10), radius: 10.0, x: 1, y: 4.0)
            
            HStack(alignment:.center){
                Button{
                    if selectedTab == .home {
                            return
                    }else{
                        selectedTab = .home
                        showDashboardView = true
                    }
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
                                    .frame(width:32, height: 30)
                                    .foregroundColor(Color("HighlightColor"))

                            }.foregroundColor(Color("HighlightColor"))
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                Image("Home")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:32, height: 30)
                            }.foregroundColor(Color.black)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
                .navigationDestination(isPresented: $showDashboardView){
                    DashboardView(user: $user)
                }
                .navigationBarBackButtonHidden(true)
                
                Button{
                    //Switch to manage
                    if selectedTab == .manage {
                            return
                    }else{
                        selectedTab = .manage
                        showSessionView = true
                    }
                }label: {
                    GeometryReader{
                        geo in
                        if selectedTab == .manage {
                            VStack(alignment: .center, spacing: 5){
                                Image("Manage")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:36, height: 36)
                                    .foregroundColor(Color("HighlightColor"))
                                
                            }.foregroundColor(Color("HighlightColor"))
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                    Image("Manage")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:36, height: 36)
                            }.foregroundColor(Color.black)
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
                .navigationDestination(isPresented: $showSessionView){
                    SessionView(user: user)
                    
                }
                .navigationBarBackButtonHidden(true)
                
                Button{
                    if selectedTab == .profile {
                            return
                    }else{
                        selectedTab = .profile
                        showProfileView = true
                    }
                    
                    //Switch to Home
                }label: {
                    GeometryReader{
                        geo in
                        if selectedTab == .profile {
                            VStack(alignment: .center, spacing: 5){
                                //                                Image(systemName: "person.fill")
                                Image("User")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:34, height: 34)
                                    .foregroundColor(Color("HighlightColor"))
                            }.foregroundColor(Color("HighlightColor"))
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }else{
                            VStack(alignment: .center, spacing: 5){
                                Image("User")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:34, height: 34)
                            }.foregroundColor(Color.black)
                                .frame(width: geo.size.width, height: geo.size.height)
                            
                        }
                    }
                } .navigationDestination(isPresented: $showProfileView){
                    ProfileView(user: $user)
                    
                }
                .navigationBarBackButtonHidden(true)
                
                
            }.frame(width: 335, height: 90)
        }
        
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar(selectedTab: .constant(.manage))
//    }
//}

