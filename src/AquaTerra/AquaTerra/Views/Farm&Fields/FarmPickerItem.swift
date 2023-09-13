//
//  FarmPickerItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

struct FarmPickerItem: View {
    
    let farm: Farm
    
    @State private var isSelected = false

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 5)
            
            HStack {
                
                Button {
                    selectFarm()
                } label: {
                    Image(isSelected ? "FarmPickSelected" : "FarmPickNormal")
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
        .frame(height: 60)
        .gesture(TapGesture().onEnded({
            
            selectFarm()
        }))
    }
    
    func selectFarm() {
        
        isSelected.toggle()
    }
}

struct FarmPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let farm = Farm(id: UUID().uuidString, user: "demo", name: "Test Farm")
        FarmPickerItem(farm: farm)
    }
}
