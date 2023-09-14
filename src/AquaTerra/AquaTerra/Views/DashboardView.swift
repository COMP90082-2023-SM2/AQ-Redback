//
//  DashboardView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI
import Amplify

struct DashboardView: View {
    @State var selectedTab: Tabs = .home
    @Binding var user: AuthUser
    
    var body: some View {
        NavigationStack{
            VStack{
                CustomHeaderView(title: "Dashboard").frame(alignment: .top)
                    .frame(alignment: .top)
                    .frame(height: 60)
                    .background(Color.green)
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, user: $user)
                
            }
            
        } .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView(selectedTab: .home)
//    }
//}
