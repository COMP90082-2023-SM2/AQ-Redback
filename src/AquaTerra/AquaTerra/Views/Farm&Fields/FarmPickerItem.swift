//
//  FarmPickerItem.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import SwiftUI

struct FarmPickerItem: View {
    
    let farm: Farm
    
    @ObservedObject var viewModel: FarmsViewModel

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
            
            HStack {
                
                Button {
                    selectFarm()
                } label: {
                    Image(viewModel.currentFarm?.id == farm.id ? "FarmPickSelected" : "FarmPickNormal")
                        .resizable()
                        .frame(width: 38, height: 38)
                        .tint(Color.farmNameColor)
                }
                
                Text("\(farm.name)")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .gesture(TapGesture().onEnded({
            
            selectFarm()
        }))
    }
    
    func selectFarm() {
        
        viewModel.currentFarm = farm
    }
}

struct FarmPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let farm = Farm(id: UUID().uuidString, user: "Demo", name: "Farm1")
        
        FarmPickerItem(farm: farm, viewModel: FarmsViewModel.previewViewModel())
    }
}
