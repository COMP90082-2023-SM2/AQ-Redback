//
//  DashboardMoistureDepthPicker.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardMoistureDepthPicker: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(MoistureDepth.allCases) { it in
                    Button {
                        dashboardViewModel.moistureDepthSelection = it
                    } label: {
                        if dashboardViewModel.moistureDepthSelection == it {
                            Text(it.rawValue)
                                .font(.custom("OpenSans-SemiBold", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 147, height: 39)
                                .background(Color("HighlightColor"))
                                .clipShape(Capsule(style: .continuous))
                        } else {
                            Text(it.rawValue)
                                .font(.custom("OpenSans-SemiBold", size: 12))
                                .foregroundColor(Color("HighlightColor"))
                                .frame(width: 147, height: 39)
                                .clipShape(Capsule(style: .continuous))
                                .overlay {
                                    Capsule(style: .continuous)
                                        .stroke()
                                        .fill(Color("HighlightColor"))
                                }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal)
        }
    }
}

enum MoistureDepth: String, CaseIterable, Identifiable {
    var id: Self {
        self
    }

    case depth50 = "30-50cm Underground", depth100 = "100cm Underground", depth150 = "150cm Underground"
}
