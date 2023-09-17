//
//  FarmRegisterSubmitView.swift
//  AquaTerra
//
//  Created by Joyce on 2023/9/14.
//

import SwiftUI

struct FarmRegisterSubmitView: View {
    
    @State private var state = true
    
    @ObservedObject var viewModel: FarmsViewModel

    var actionBlock: ButtonActionBlock?
    
    var body: some View {
        VStack {
            HStack{
                Text("Please submit to finish registering your field:")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
            Text(viewModel.newFarm.fieldName)
                .foregroundColor(.init(hex: "#80B240"))
                .font(.system(size: 16,weight: .bold))
                .padding(.bottom)
            GRButton(enable: $state, title: "Submit",buttonAction: actionBlock)
                .frame(height: 50)
            Spacer()
        }
    }
}

struct FarmRegisterSubmitView_Previews: PreviewProvider {
    static var previews: some View {
        FarmRegisterSubmitView(viewModel: FarmsViewModel.previewViewModel())
    }
}
