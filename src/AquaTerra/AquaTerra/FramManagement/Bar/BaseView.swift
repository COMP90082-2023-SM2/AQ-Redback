//
//  FMBarView.swift
//  Gateways
//
//  Created by ... on 2023/9/10.
//

import SwiftUI
 
struct BaseView : View {
    @ObservedObject var control = BaseBarModel.share
    @State private var selectIdx = 0
    private var barIcons = ["tabbar_1","tabbar_2","tabbar_3"]
    
    var body: some View {
        ZStack(alignment: .bottom){
            switch selectIdx {
            case 0 : NavigationView {
                HStack{}            }
            case 1: FManagementView()
            case 2: NavigationView {
                HStack{}
            }
            default : HStack{}
            }
            if control.showTab {
                CusTabbarView(selected:$selectIdx,items: barIcons)
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
    static var previews: some View {
        BaseView()
    }
}
