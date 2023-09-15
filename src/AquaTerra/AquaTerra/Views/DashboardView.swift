//
//  DashboardView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 13/9/2023.
//

import SwiftUI
import Amplify

struct DashboardView: View {
    

    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    @State private var fieldData: [FieldData] = []
    @Binding var user: AuthUser
    @State private var isShowingSensorListView = false
    @ObservedObject private var viewModel = SessionViewViewModel()
    
    
    @State var selectedTab: Tabs = .home
    
    @State var currentTab : Int = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                CustomHeaderView(title: "Dashboard").frame(height: 60)
                
                ZStack(alignment: .top){
                    TabView(selection: self.$currentTab){
                        InfoTab().tag(0)
                        MoistureTab().tag(1)
                        TemperatureTab().tag(2)
                        BatteryView().tag(3)
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                    
                    TabBarView(currentTab: self.$currentTab)
                    
                }.frame(height: 300)
            }
            


            Spacer()
//            CustomTabBar(selectedTab: $selectedTab, user: $user)

        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                MGViewModel.share().setupUser(user: user.userId)
                    
            }
        
    }
}
struct TabBarView: View{
    @Binding var currentTab: Int
    var tabBarOptions : [String] = ["Information", "Moisture", "Temperature", "Battery"]
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack(spacing: 30){
                ForEach(Array(
                        zip(self.tabBarOptions.indices,
                            self.tabBarOptions)),
                    id: \.0,
                    content:{
                        index, name in
                    TabBarItem(tabBarItemName: name, currentTab: self.$currentTab, tab: index)
                    }
                )
                
            }.padding(.horizontal, 30)

        }.background(Color.white)
            .frame(height: 40)
        
        Divider().overlay(Color.red.opacity(0.01))
    }
       
}



struct TabBarItem: View{
    var tabBarItemName: String
    @Namespace var namespace
    @Binding var currentTab : Int
    var tab : Int
    
    var body: some View {
        Button{
            self.currentTab = tab
        }label: {
            VStack(spacing: 10){
                Spacer()
                if currentTab == tab{
                    Text(tabBarItemName)
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(Color("HighlightColor"))
                    Color("HighlightColor")
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                }else{
                    Text(tabBarItemName)
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(Color.black)
                    Color.clear.frame(height: 3)
                }
   
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
        
    }
}
//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView(selectedTab: .home)
//    }
//}
