//
//  ZoneRegisterSubmitView.swift
//  AquaTerra
//
//  Created by WD on 2023/10/12.
//

import SwiftUI

struct ZoneRegisterSubmitView: View {
    
    @State private var state = true
    
    @ObservedObject var viewModel: FieldViewModel

    var actionBlock: ButtonActionBlock?
    
    var body: some View {
        VStack {
            HStack{
                Text("Please submit to finish registering your Zone:")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
            if !viewModel.editZone.name.isEmpty {
                Text(viewModel.editZone.name)
                    .foregroundColor(.init(hex: "#80B240"))
                    .font(.system(size: 16,weight: .bold))
                    .padding(.bottom)
            } else {
                Text(viewModel.newZone.name)
                    .foregroundColor(.init(hex: "#80B240"))
                    .font(.system(size: 16,weight: .bold))
                    .padding(.bottom)
            }
            
            GRButton(enable: $state, title: "Submit",buttonAction: actionBlock)
                .frame(height: 50)
            Spacer()
        }
    }
}

struct ZoneRegisterSubmitView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneRegisterSubmitView(viewModel: FieldViewModel.previewViewModel())
    }
}

