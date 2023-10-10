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
                CustomHeaderView(title: "User Profile")
                    .frame(alignment: .top)
                    .frame(height: 60)
                
                Text("Please visit website to modify profile details.").font(.custom("OpenSans-SemiBold", size: 16)).padding(.bottom, 10).padding(.top, 20).padding(.horizontal, 15).background(Color("bar"))
                
                List{
                    ProfileItemView(profileDetail: user.username, profileTitle: "Username")
                    ProfileItemView(profileDetail: "29-08-2024", profileTitle: "Expired Date")
                    ProfileItemView(profileDetail: "full", profileTitle: "Subscription Type")
                    ProfileItemView(profileDetail: "+61405312574", profileTitle: "Phone Number")
                    ProfileItemView(profileDetail: "000 Demo St", profileTitle: "Address")
                    ProfileItemView(profileDetail: "yiyuanw1@student.unimelb.edu.au", profileTitle: "Email")
                }
                .buttonStyle(PlainButtonStyle())
                .scrollIndicators(.hidden)
                .listStyle(PlainListStyle())
                .padding(.trailing, 25)
                
                
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

                                

//                CustomTabBar(selectedTab: $selectedTab, user: $user)
                
            }.padding(.bottom, 50)
            
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
