//
//  EditViewListItem.swift
//  AquaTerra
//
//  Created by Davincci on 16/9/2023.
//

import SwiftUI

struct EditViewListItem: View {
    @State var title: String
    @Binding var detail: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("OpenSans-SemiBold", size: 16))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Allow text to expand to the left
            Spacer()
            
            TextField("", text: Binding<String>(
                get: { self.detail ?? "" },
                set: { self.detail = $0 }
            ), onCommit: {
                
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
