//
//  SessionView.swift
//  AquaTerra
//
//  Created by Davincci on 30/8/2023.
//

import Amplify
import SwiftUI

struct SessionView: View {

    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel

    @State private var fieldData: [FieldData] = []

    let user: AuthUser

    @State private var isShowingSensorListView = false

    @ObservedObject private var viewModel = SessionViewViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("You sign in as \(user.username) using Amplify!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)

                Spacer()
                Button("Sign Out", action: {
                    sessionViewViewModel.signOut()
                })

                Button("My Sensors", action: {
                    sessionViewViewModel.fetchFieldData { result in
                        switch result {
                        case .success(let data):
                            self.fieldData = data
                            self.isShowingSensorListView = true
                        case .failure(let error):
                            print("Error fetching sensor data: \(error)")
                        }
                    }
                })
                .navigationDestination(isPresented: $isShowingSensorListView){
                    SensorListView(fieldData: self.fieldData, viewModel: viewModel)
                }

                List(fieldData, id: \.field_id) { sensor in
                    Text("Field Name: \(sensor.field_name)")
                }
            }
            .navigationBarTitle("Session")
        }
    }
}
