//
//  FarmPickerItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

struct FarmPickerItem: View {
    
    let farm: Farm //Farm object, used to display farm information
    
    @Binding var currentPickedFarm: String // Bind to the name of the currently selected farm

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
            
            HStack {
                
                Button {
                    selectFarm() //Select the farm when the user clicks the button
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
            
            selectFarm() // select farm when user clicks on entire view
        }))
    }
    
    func selectFarm() {
        
        currentPickedFarm = farm.name //Set the currently selected farm name
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
