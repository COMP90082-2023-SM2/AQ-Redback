//
//  EditViewListItem.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI

struct EditViewListItem: View {
    @State var title: String
    @Binding var detail: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("OpenSans-SemiBold", size: 16))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Allow text to expand to the left
            
            Spacer()
            
            TextField("", text: $detail, onCommit: {
                // Perform action when editing is complete
            })
            .font(.custom("OpenSans-SemiBold", size: 16))
            .frame(maxWidth: 100)
            .multilineTextAlignment(.trailing)
        }
        .background(Color.white)
        .padding(.horizontal, 30)
        .frame(height: 60)
        
        Divider()
            .frame(maxWidth: .infinity)
            .foregroundColor(Color("bar"))
            .padding(0)
    }
}



//struct EditViewListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        EditViewListItem(title:"Alias", detail: "null")
//    }
//}
