//
//  FarmPickerView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

struct FarmPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FarmsViewModel
    
    var body: some View {
        
        VStack {
            if let farms = viewModel.farms {
                ForEach(farms) { farm in
                    FarmPickerItem(farm: farm)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Choose A Farm")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button {
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    HStack {
                        Image("arrow-left-s-fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Back")
                            .foregroundColor(.navigationTintColor)
                    }
                    .frame(width: 70)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    onClickedSelectButton()
                } label: {
                    Text("Select")
                        .font(.system(size: 16))
                        .padding(12)
                        .foregroundColor(.white)
                        .background(Color.farmNameColor)
                        .cornerRadius(5)
                }
            }
        }
    }
    
    func onClickedSelectButton() {
        
    }
}

struct FarmPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FarmPickerView(viewModel: FarmsViewModel(currentUserName: "demo"))
    }
}
