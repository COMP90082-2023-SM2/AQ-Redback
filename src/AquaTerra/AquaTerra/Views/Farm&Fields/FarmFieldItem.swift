//
//  FarmFieldItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

struct FarmFieldItem: View {
    
    var index: Int = 0
    
    let field: Field
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 5)
            
            HStack {
                Text("\(index)")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text(field.name)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text(field.crop ?? "")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
                
                Button {
                    showFieldDetail()
                } label: {
                    Image("FieldDetailButton")
                        .resizable()
                        .frame(width: 38, height: 38)
                }
                
                Button {
                    deleteField()
                } label: {
                    Image("FieldDeleteButton")
                        .resizable()
                        .frame(width: 38, height: 38)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
    
    func showFieldDetail() {
        
    }
    
    func deleteField() {
        
    }
}

struct FarmFieldItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let filed = Field(id: UUID().uuidString, user: "demo", name: "Demo", farm: "Test Farm", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)
        FarmFieldItem(index: 1, field: filed)
    }
}
