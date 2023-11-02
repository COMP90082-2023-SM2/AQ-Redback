//
//  FarmRegisterSubmitView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/14.
//

import SwiftUI

struct FarmRegisterSubmitView: View {
    
    @State private var state = true //Control the state of the submit button
    
    @ObservedObject var viewModel: FarmsViewModel

    var actionBlock: ButtonActionBlock? // Operation callback function when the button is clicked
    
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
