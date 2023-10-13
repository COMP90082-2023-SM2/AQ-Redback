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
                        
                        NavigationLink {
                            FarmsView(viewModel: FarmsViewModel(currentUserName: user.username))
                        } label: {
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
                        
                        NavigationLink {
                            FieldZonesView(viewModel: FieldViewModel.shared)
                        } label: {
                            ManageCardView(imgName: "Irrigation Zones", TextName: "My Irrigation Zones")
                        }
                    }.padding(.vertical, 37)
                    
                    Spacer()
    //                CustomTabBar(selectedTab: $selectedTab, user: $user)
                }
            }
            .onAppear {
                FieldViewModel.shared.currentUserName = user.username
                MGViewModel.share().setupUser(user: user.username)
                    
            }
            
        }

    }
    
}
