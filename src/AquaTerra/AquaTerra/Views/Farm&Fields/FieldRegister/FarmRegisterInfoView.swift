//
//  FarmRegisterInfoView.swift
//  AquaTerra
//
//  Created by Joyce on 2023/9/14.
//

import SwiftUI

struct FarmRegisterInfoView: View {
    
    @ObservedObject var viewModel: FarmsViewModel

    @Binding var enable: Bool
    
    @FocusState private var farmInputFocused: Bool
    @FocusState private var fieldInputFocused: Bool

    var clickAction: ButtonActionBlock?

    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            
            HStack {
                Text("Please enter a farm name and a field name to proceed.")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
//            Divider().frame(height: 0.5)
            HStack {
                Text("Farm Name")
                    .font(.custom("OpenSans-Bold", size: 16))
                    .frame(width: 105, alignment: .leading)
                
//                Spacer().frame(width: 80)
                
                TextField("Enter a name here",text: $viewModel.newFarm.name)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("Placeholder"))
                    .padding([.horizontal], 30)
                    .accentColor(Color("ButtonGradient2"))
                    .focused($farmInputFocused)
            }
            .frame(maxWidth: .infinity, idealHeight: 68)
            .padding()
            .background {
                Rectangle()
                    .fill(.white)
                    .shadow(radius: 0.5)
            }
            HStack {
                Text("Field Name")
                    .font(.custom("OpenSans-Bold", size: 16))
                    .frame(width: 105, alignment: .leading)
                                
                TextField("Enter a name here",text: $viewModel.newFarm.fieldName)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("Placeholder"))
                    .padding([.horizontal], 30)
                    .accentColor(Color("ButtonGradient2"))
                    .focused($fieldInputFocused)
            }
            .frame(maxWidth: .infinity, idealHeight: 68)
            .padding()
            .background {
                Rectangle()
                    .fill(.white)
                    .shadow(radius: 0.5)
            }
            GRButton(enable: $enable,title: "Next",buttonAction: {
                
                farmInputFocused = false
                fieldInputFocused = false

                clickAction?()
            })
                .frame(height: 50)
                .padding(.top)
        }
        .onAppear {
            if !viewModel.currentFarmName.isEmpty {
                viewModel.newFarm.name = viewModel.currentFarmName
            }
        }
    }
}

struct FarmRegisterInfoView_Previews: PreviewProvider {
    
    @State static var text = ""
    
    static var isTextEmpty : Binding<Bool> {
        Binding<Bool>(
            get: {
                return !text.isEmpty
            },
            set: { _ in }
        )
    }

    static var previews: some View {
        
        FarmRegisterInfoView(viewModel: FarmsViewModel.previewViewModel(), enable: isTextEmpty)
    }
}
