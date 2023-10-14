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
            Text("Current Field:  ")
                .font(.custom("OpenSans-SemiBold", size: 16))
            Text("\(dashboardViewModel.fieldSelection.field_name)")
                .foregroundColor(Color("GreenHightlight"))
                .font(.custom("OpenSans-Bold", size: 16))
            Spacer()
            NavigationLink {
                FieldItems(viewModel: dashboardViewModel)
            } label: {
                Text("Change")
                    .font(.custom("OpenSans-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .padding(5)
                    .padding(.horizontal, 10)
                    .background(Color("GreenHightlight"))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .background(Color("Hint").opacity(0.7))
    }
}

