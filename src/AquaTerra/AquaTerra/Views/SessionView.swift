//
//  SessionView.swift
//  AquaTerra
//
//  Created by jiakang on 13/9/2023.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    @State var selectedTab: Tabs = .manage

    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel

    @State private var fieldData: [FieldData] = []
    

    @State var user: AuthUser

    @State private var isShowingSensorListView = false

    @ObservedObject private var viewModel = SessionViewViewModel()

    var body: some View {
        NavigationStack {
            VStack() {
                CustomHeaderView(title: "Farm Management")
                    .frame(alignment: .top)
                    .frame(height: 60)
                    .background(Color.green)
                
                VStack(spacing: 24){
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
                           
                    }
                    
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
                }.padding(.vertical, 37)
             
                

                Spacer()
 
                CustomTabBar(selectedTab: $selectedTab, user: $user)
                
            }
        }
        .onAppear {
            MGViewModel.share().setupUser(user: user.userId)
                
        }
    }
    
}
