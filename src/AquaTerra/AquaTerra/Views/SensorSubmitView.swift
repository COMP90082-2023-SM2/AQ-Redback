//
//  SensorButtonView.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI

struct SensorSubmitView: View {
    @State private var state = true
    var gateway : String
    var actionBlock : ButtonActionBlock?
    var body: some View {
        VStack{
            HStack{
                Text("Please submit this form to finish registering your new gateway:")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom,10)
            
            Text(gateway)
                .foregroundColor(.init(hex: "#80B240"))
                .font(.system(size: 16,weight: .bold))
                .padding(.bottom)
            GRButton(enable: $state,title: "Submit",buttonAction: actionBlock)
                .frame(height: 50)
            Spacer()
        }
    }
}

