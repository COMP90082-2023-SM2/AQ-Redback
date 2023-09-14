//
//  FarmFieldItem.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import SwiftUI

struct FarmFieldItem: View {
    
    var index: Int = 0
    
    let field: Field
    
    @ObservedObject var viewModel: FarmsViewModel

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
        
        let filed = Field(id: UUID().uuidString, user: "demo", name: "Demo", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)
        FarmFieldItem(index: 1, field: filed, viewModel: FarmsViewModel.previewViewModel())
    }
}
