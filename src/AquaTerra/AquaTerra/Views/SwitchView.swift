//
//  SwitchView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 15/9/2023.
//

import Amplify
import SwiftUI

// This tab bar which can be navigate to Dashboard, Farm management page and User profile page
struct SwitchView: View {
    
    @State var selectedTab: Tabs = .manage
    
    @ObservedObject private var tabBarViewModel = BaseBarModel.share

    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    @State private var fieldData: [FieldData] = []
    @State var user: AuthUser
    @State private var isShowingSensorListView = false
    @ObservedObject private var viewModel = SessionViewViewModel()
    
    var body: some View {
        ZStack {
                VStack {
                    if selectedTab == .home {
                        DashboardView(user:$user).frame(alignment: .top)
                    }
                    
                    if selectedTab == .profile {
                        ProfileView(user:$user)
                    }
                    
                    if selectedTab == .manage {
                        SessionView(user:$user)
                    }
                }
            
                VStack{
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab, user: $user)
                        .opacity(tabBarViewModel.showTab ? 1.0 : 0)
                }
        }
//        .ignoresSafeArea(.all)
        .onAppear {
            MGViewModel.share().setupUser(user: user.username)
        }
    }
    
}
