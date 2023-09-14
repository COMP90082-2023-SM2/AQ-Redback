//
//  FarmPickerView.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import SwiftUI

struct FarmPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FarmsViewModel
    
    var body: some View {
        
        VStack {
            if let farms = viewModel.farms {
                
                Divider().frame(height: 0.5)
                
                ForEach(farms) { farm in
                    FarmPickerItem(farm: farm, viewModel: viewModel)
                        .frame(height: 68)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Choose A Farm")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 70,height: 17)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    selectCurrentFarm()
                } label: {
                    Text("Select")
                        .font(.system(size: 16))
                        .padding(12)
                        .foregroundColor(.white)
                        .background(Color.farmNameColor)
                        .cornerRadius(5)
                        .frame(width: 86, height: 29)
                }
            }
        }
    }
    
    func selectCurrentFarm() {
        
    }
}

struct FarmPickerView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            FarmPickerView(viewModel: FarmsViewModel.previewViewModel())
        }
    }
}
