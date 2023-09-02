//
//  FMBarView.swift
//  Gateways
//
//  Created by ... on 2023/9/10.
//

import SwiftUI
import Amplify
 
struct MainTabView : View {
    @EnvironmentObject var sessionModel : SessionViewViewModel
    
    @ObservedObject private var control = BaseBarModel.share
    @State private var selectIdx = 0

    var user : AuthUser
    
    init(user: AuthUser) {
        self.user = user
        MGViewModel.share().setupUser(user: user.username)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            switch selectIdx {
            case 0 : NavigationView {
                HStack{}
            }
            case 1: FManagementView()
            case 2: NavigationView {
                SessionView(sessionViewViewModel: sessionModel,user: user)
            }
            default : HStack{}
            }
            if control.showTab {
                CusTabbarView(selected:$selectIdx,items: ["tabbar_1","tabbar_2","tabbar_3"])
                    .frame(height: 96)
                    .background(.white)
                    .cornerRadius(50)
                    .shadow(color: .gray.opacity(0.3), radius: 2)
                    .padding()
            }
        }
    }
}

struct FMBarView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    static var previews: some View {
        MainTabView(user:DummyUser())
    }
}
