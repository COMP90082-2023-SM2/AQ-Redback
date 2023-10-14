//
//  DashboardFieldPicker.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardFieldPicker: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    var body: some View {
        HStack(spacing: 0) {
            Text("Current Field: ")
                .font(.custom("OpenSans-SemiBold", size: 16))
            Text("\(dashboardViewModel.fieldSelection.field_name)")
                .foregroundColor(Color("GreenHightlight"))
                .font(.custom("OpenSans-SemiBold", size: 16))
            Spacer()
            Menu {
                ForEach(dashboardViewModel.fields) { it in
                    Button(it.field_name) {
                        dashboardViewModel.fieldSelection = it
                    }
                    .font(.custom("OpenSans-SemiBold", size: 14))
                }
            } label: {
                Text("Change")
                    .font(.custom("OpenSans-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color("GreenHightlight"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
        }
        .padding(.horizontal)
    }
}

