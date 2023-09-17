//
//  SessionView.swift
//  AquaTerra
//
//  Created by Davincci on 26/8/2023.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    @State var selectedTab: Tabs = .manage
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    @State private var fieldData: [FieldData] = []
    @Binding var user: AuthUser
    @State private var isShowingSensorListView = false

    @State private var isShowingFarmsView = false
    
    @ObservedObject private var viewModel = SessionViewViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    CustomHeaderView(title: "Farm Management")
                        .frame(alignment: .top)
                        .frame(maxHeight: 20)
                    
                    Spacer().frame(height: 60)
                    
                    Text("Farm Management")
                        .font(.custom("OpenSans-ExtraBold", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 76)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 15)
                }.ignoresSafeArea()
                    .frame(maxHeight: 127)
                
                NavigationLink {
                    MGatewaysView()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 318, height: 110)

                        Image("Gateway")
                            .resizable()
                            .aspectRatio(2,contentMode: .fill)
                            .frame(width: 318, height: 110)
                            .cornerRadius(10)
                            
                    
                        Text("My Gateways")
                            .font(.custom("OpenSans-ExtraBold", size: 20))
                            .foregroundColor(Color.white)
                    }.frame(width: 318, height: 110)
                       
                }.padding(.top,13)

                
//                Button{
//
//                }label: {
//
//                }.padding(.top,13)
                
     
//
//                Text("You sign in as \(user.username) using Amplify!")
//                    .font(.largeTitle)
//                    .multilineTextAlignment(.center)
                
                Button {
                    
                    isShowingFarmsView.toggle()

                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 318, height: 110)

                        Image("Farm")
                            .resizable()
                            .aspectRatio(2,contentMode: .fill)
                            .frame(width: 318, height: 110)
                            .cornerRadius(10)
                            
                        Text("My Farm and Fields")
                            .font(.custom("OpenSans-ExtraBold", size: 20))
                            .foregroundColor(Color.white)
                    }.frame(width: 318, height: 110)
                        
                }
                .navigationDestination(isPresented: $isShowingFarmsView) {
                    
                    FarmsView(viewModel: FarmsViewModel(currentUserName: user.username))
                }


                Button{
                    sessionViewViewModel.fetchFieldData { result in
                        switch result {
                        case .success(let data):
                            self.fieldData = data
                            self.isShowingSensorListView = true
                        case .failure(let error):
                            print("Error fetching sensor data: \(error)")
                    VStack(spacing: 24){
                        NavigationLink {
                            MGatewaysView()
                        } label: {
                            ManageCardView(imgName: "Gateway", TextName: "My Gateways")
                        }
                        
                        Button{
                            
                        }label: {
                            ManageCardView(imgName: "Farm", TextName: "My Farm and Fields")
                        }
                        
                        Button{
                            sessionViewViewModel.fetchFieldData { result in
                                switch result {
                                case .success(let data):
                                    self.fieldData = data
                                    self.isShowingSensorListView = true

                                case .failure(let error):
                                    print("Error fetching sensor data: \(error)")
                                }
                            }
                        }label:{
                            ManageCardView(imgName: "Sensor", TextName: "My Sensors")
                        }
                        .navigationDestination(isPresented: $isShowingSensorListView){
                            SensorListView(fieldData: self.fieldData, viewModel: viewModel)
                        }
                        
                        Button{
                            
                        }label: {
                            ManageCardView(imgName: "Irrigation Zones", TextName: "My Irrigation Zones")
                        }
                    }.padding(.vertical, 37)
                    
                    Spacer()
    //                CustomTabBar(selectedTab: $selectedTab, user: $user)
                }
            }
            .onAppear {
                MGViewModel.share().setupUser(user: user.username)
                    
            }
            
        }

    }
    
}
