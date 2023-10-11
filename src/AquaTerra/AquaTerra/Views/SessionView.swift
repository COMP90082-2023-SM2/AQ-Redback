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
    @State private var isShowingZonesView = false
    @ObservedObject private var viewModel = SessionViewViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    CustomHeaderView(title: "Farm Management")
                        .frame(alignment: .top)
                        .frame(maxHeight: 20)
                    
                    Spacer().frame(height: 60)
                    
                    VStack(spacing: 24){
                        NavigationLink {
                            MGatewaysView()
                        } label: {
                            ManageCardView(imgName: "Gateway", TextName: "My Gateways")
                        }
                        
                        Button {
                            isShowingFarmsView.toggle()
                        } label: {
                            ManageCardView(imgName: "Farm", TextName: "My Farm and Fields")
                                
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
                                }
                            }
                        }label:{
                            ManageCardView(imgName: "Sensor", TextName: "My Sensors")
                        }
                        .navigationDestination(isPresented: $isShowingSensorListView){
                            SensorListView(fieldData: self.fieldData, viewModel: viewModel)
                        }
                        
                        Button{
                            isShowingZonesView.toggle()
                        }label: {
                            ManageCardView(imgName: "Irrigation Zones", TextName: "My Irrigation Zones")
                        }
                        .navigationDestination(isPresented: $isShowingZonesView) {
                            
                            FieldZonesView(viewModel: FieldViewModel(currentUserName: user.username))
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
