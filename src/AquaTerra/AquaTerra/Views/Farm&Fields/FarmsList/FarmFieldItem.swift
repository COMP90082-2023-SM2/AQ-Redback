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
    
    @ObservedObject var viewModel: FarmsViewModel

    @Binding var deleteAlertShowup : Bool

    var deleteAction: ((Field) -> Void)?
    
    var viewDetailAction: ((Field) -> Void)?

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 1)
            GeometryReader { geometry in
                VStack{
                    Spacer()
                    HStack {
                        Text("\(index)")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .frame(width: 30, alignment: .leading) // Fixed width
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer().frame(width: 40)
                        
                        Text(field.name)
                            .font(.custom("OpenSans-Regular", size: 14))
                            .frame(width: 60, alignment: .leading) // Fixed width
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        Text(field.crop ?? "")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .frame(width: 40, alignment: .leading) // Fixed width
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        
                        Button {
                            deleteField()
                        } label: {
                            Image("FieldDeleteButton")
                                .resizable()
                                .frame(width: 38, height: 38)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.trailing, 20)
            }
        }
        .frame(height: 60)
    }
    
    func showFieldDetail() {
        
        viewDetailAction?(field)
    }
    
    func deleteField() {
                
        deleteAction?(field)
    }
}

struct FarmFieldItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let filed = Field(id: UUID().uuidString, user: "demo", name: "Demo", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)
        let show: Binding<Bool> = Binding<Bool> {
            return true
        } set: { _ in }

        
        FarmFieldItem(index: 1, field: filed, viewModel: FarmsViewModel.previewViewModel(), deleteAlertShowup: show)
    }
}
