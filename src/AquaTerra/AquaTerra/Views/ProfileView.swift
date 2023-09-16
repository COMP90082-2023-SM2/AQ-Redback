//
//  ProfileView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 14/9/2023.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    @State var selectedTab: Tabs = .profile
    @Binding var user: AuthUser
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                CustomHeaderView(title: "My Profile")
                    .frame(alignment: .top)
                    .frame(height: 60)
                
                Button {
                    sessionViewViewModel.signOut()
                }
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("ButtonGradient1"), Color("ButtonGradient2")]), startPoint: .leading, endPoint: .trailing))
                            .frame(height: 50)
                            .frame(width: 318)
                            
                        Text("Sign Out")
                            .foregroundColor(Color.white)
                            .font(.custom("OpenSans-Regular", size: 16))
                            .bold()
                            .padding([.horizontal], 15)
                            .padding(.vertical,20)
                            
                        }
                }.padding(.top, 10)
                                
                Spacer()
//                CustomTabBar(selectedTab: $selectedTab, user: $user)
                
            }
            
        } .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
