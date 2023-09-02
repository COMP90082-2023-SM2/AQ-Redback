//
//  FarmManagement.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import SwiftUI

struct FManagementView: View {
    
    var models = [
        FMModel(img: "MyGateways_ic", target:AnyView(MGatewaysView())),
        FMModel(img: "MyFarms_ic", target: AnyView(Text("hh"))),
        FMModel(img: "MySensors_ic", target: AnyView(Text("h"))),
        FMModel(img: "MyIrrigation_ic", target: AnyView(Text("hh"))),
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                FMNavigationBarView(title: "Farm Management")
                    .frame(height: 60)
                Spacer()
                List{
                    ForEach(0..<models.count,id: \.self) { index in
                        ZStack(content: {
                            Image(models[index].img)
                                .foregroundColor(.black)
                            NavigationLink(destination: models[index].target) {
                            }
                            .opacity(0)
                        })
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

struct FMModel {
    var img : String
    var target : AnyView
}

struct FarmManagement_Previews: PreviewProvider {
    static var previews: some View {
        FManagementView()
    }
}
