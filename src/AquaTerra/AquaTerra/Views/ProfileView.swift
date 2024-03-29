//
//  ProfileView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 14/9/2023.
//

import SwiftUI
import Amplify
import AWSMobileClient

// This user profile page
struct ProfileView: View {
    @State var selectedTab: Tabs = .profile
    @Binding var user: AuthUser
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    @State var subType: String?
    @State var phoneNumber: String?
    @State var expiredDate: String?
    @State var userAddress: String?
    @State var userEmail: String?

    var body: some View {
        
        NavigationStack{
            
            VStack{
                CustomHeaderView(title: "User Profile")
                    .frame(alignment: .top)
                    .frame(height: 60)
                
                Text("Please visit website to modify profile details.").font(.custom("OpenSans-SemiBold", size: 16)).frame(maxWidth: .infinity).padding(.bottom, 20).padding(.top, 20).padding(.horizontal, 15).background(Color("bar"))
                
                List{
                    
                    ProfileItemView( profileTitle: "Username", profileDetail: user.username).listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    ProfileItemView( profileTitle: "Expired Date", profileDetail: expiredDate ?? "").listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    ProfileItemView( profileTitle: "Subscription Type", profileDetail:subType ?? "").listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    ProfileItemView( profileTitle: "Phone Number", profileDetail: phoneNumber ?? "").listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    ProfileItemView( profileTitle: "Address", profileDetail: userAddress ?? "").listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    ProfileItemView( profileTitle: "Email", profileDetail: userEmail ?? "").listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    
                }
                .buttonStyle(PlainButtonStyle())
                .scrollIndicators(.hidden)
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity)
                
                
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
                
            }.padding(.bottom, 100)
            
        } .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                        Task {
                             fetchAttributes()
                        }
                    }
        
        
    }
    
    // fetch each attribute value from user pool
    func fetchAttributes() {
        AWSMobileClient.default().getUserAttributes { (attributes, error) in
             if(error != nil){
                print("ERROR")
             }else{
                if let attributesDict = attributes{
                    subType = attributesDict["custom:subscription_level"]
                    phoneNumber = attributesDict["phone_number"]
                    expiredDate = attributesDict["custom:sub_expiry_date"]
                    userAddress = attributesDict["address"]
                    userEmail = attributesDict["email"]
                    //print(attributesDict["email"])
                   //print(attributesDict["given_name"])
                }
             }
        }
    }
    
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
