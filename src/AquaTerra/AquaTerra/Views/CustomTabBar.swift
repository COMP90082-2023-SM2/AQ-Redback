//
//  CustomTabBar.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI
import Amplify

enum Tabs: String, CaseIterable {
    case home
    case manage
    case profile
}

// This custom tab bar which can be navigate to Dashboard, Farm management page and User profile page
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
                        }label: {
                            TabBarItemIcon(imgName: "Home", isActive: selectedTab == .home, width: 32, height: 30)
                        }

                        Button{
                            //Switch to manage
                            if selectedTab == .manage {
                                    return
                            }else{
                                selectedTab = .manage
                                showSessionView = true
                            }
                        }label: {
                            TabBarItemIcon(imgName: "Manage", isActive: selectedTab == .manage, width: 36, height: 36)
                        }

                        Button{
                            //Switch to Home
                            if selectedTab == .profile {
                                    return
                            }else{
                                selectedTab = .profile
                                showProfileView = true
                            }
                        }label: {
                            TabBarItemIcon(imgName: "User", isActive: selectedTab == .profile, width: 34, height: 34)
                        }

                    }.frame(width: 335, height: 90)
                }
        
    }
    
}
