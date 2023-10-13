//
//  FieldPickerItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/10.
//

import SwiftUI

struct FieldPickerItem: View {
    
    let field: Field
    
    @Binding var currentPickedField: String

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
            
            HStack {
                
                Button {
                    selectField()
                } label: {
                    Image(currentPickedField.elementsEqual(field.name) ? "FarmPickSelected" : "FarmPickNormal")
                        .resizable()
                        .frame(width: 38, height: 38)
                        .tint(Color.farmNameColor)
                }
                
                Text("\(field.name)")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .gesture(TapGesture().onEnded({
            
            selectField()
        }))
    }
    
    func selectField() {
        
        currentPickedField = field.name
    }
}

struct FieldPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let field = Field(id: UUID().uuidString, user: "Demo", name: "Field1", farm: "Farm1", crop: nil, soil: nil, geom: "", points: "", elevation: nil)
        let bindingpickedField = Binding {
            return field.name
        } set: { _ in }

        FieldPickerItem(field: field, currentPickedField: bindingpickedField)
    }
}

