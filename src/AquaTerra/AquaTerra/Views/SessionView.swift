//
//  SessionView.swift
//  AquaTerra
//
//  Created by Davincci on 30/8/2023.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    @State var selectedTab: Tabs = .manage

    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel

    @State private var fieldData: [FieldData] = []
    

    let user: AuthUser

    @State private var isShowingSensorListView = false

    @ObservedObject private var viewModel = SessionViewViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack{
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxHeight: 127)
                        .shadow(color: Color.black.opacity(0.15), radius: 2.0, x: 0, y: 0)
                        .ignoresSafeArea()
                    
                    
                    Text("Farm Management")
                        .font(.custom("OpenSans-ExtraBold", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 76)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 15)
                }.ignoresSafeArea()
                    .frame(maxHeight: 127)
                    .background(Color.gray)
                
                
                Button{
                    
                }label: {
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
                
     
//
//                Text("You sign in as \(user.username) using Amplify!")
//                    .font(.largeTitle)
//                    .multilineTextAlignment(.center)
                
                Button{
                    
                    
                }label: {
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
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 318, height: 110)

                        Image("Sensor")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 318, height: 110)
                            .cornerRadius(10)
                            
                    
                        Text("My Sensors")
                            .font(.custom("OpenSans-ExtraBold", size: 20))
                            .foregroundColor(Color.white)
                    }.frame(width: 318, height: 110)
                    
                }.navigationDestination(isPresented: $isShowingSensorListView){
                    SensorListView(fieldData: self.fieldData, viewModel: viewModel)
                }
                
                Button{
                    
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 318, height: 110)

                        Image("Irrigation Zones")
                            .resizable()
                            .aspectRatio(2,contentMode: .fill)
                            .frame(width: 318, height: 110)
                            .cornerRadius(10)
                            
                        Text("My Irrigation Zones")
                            .font(.custom("OpenSans-ExtraBold", size: 20))
                            .foregroundColor(Color.white)
                    }.frame(width: 318, height: 110)
                        
                }
                
//                Button("Sign Out", action: {
//                    sessionViewViewModel.signOut()
//                })
//                .tint(Color("ButtonGradient1"))
//                .font(.custom("OpenSans-Bold", size: 16))
//
                Spacer()
 
                CustomTabBar(selectedTab: $selectedTab)
//                    .padding(.bottom, 30)
                
            }.ignoresSafeArea()
        }
    }
}
