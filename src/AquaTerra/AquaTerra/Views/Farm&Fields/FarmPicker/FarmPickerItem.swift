//
//  FarmPickerItem.swift
//  AquaTerra
//
//  Created by Joyce on 2023/9/13.
//

import SwiftUI

struct FarmPickerItem: View {
    
    let farm: Farm
    
    @Binding var currentPickedFarm: String

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
            
            HStack {
                
                Button {
                    selectFarm()
                } label: {
                    Image(currentPickedFarm.elementsEqual(farm.name) ? "FarmPickSelected" : "FarmPickNormal")
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
        
        currentPickedFarm = farm.name
    }
}

struct FarmPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let farm = Farm(user: "Demo", name: "Farm1")
        
        let bindingPickedFarm = Binding {
            return farm.name
        } set: { _ in }

        FarmPickerItem(farm: farm, currentPickedFarm: bindingPickedFarm)
    }
}
