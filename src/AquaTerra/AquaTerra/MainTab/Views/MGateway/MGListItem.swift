//
//  FMListItem.swift
//  Gateways
//
//  Created by ZHL on 2023/9/8.
//

import SwiftUI

typealias DeleteActionBlock = (_ id:String) -> Void

struct MGListItem : View {
    var no : String = "1"
    var gatewayId : String = "demo"
    var deleteActionBlock : DeleteActionBlock?
    var body: some View{
        VStack{
            HStack{
                Text(no)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .padding(.leading, 36)
                Spacer().frame(width: 51)
                Text(gatewayId)
                    .font(.custom("OpenSans-Regular", size: 14))
                Spacer()
                Image("close-circle-fill").resizable()
                    .frame(width: 38,height: 38)
                    .padding(.trailing,36)
                    .onTapGesture {
                        deleteActionBlock?(gatewayId)
                    }
               
            }
            .background(Color.white)
            
            Divider()
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("bar"))
                .frame(height: 2)
            
        }.frame(height: 68)
        
    }
}

struct FMListItem_Previews: PreviewProvider {
    static var previews: some View {
        MGListItem()
    }
}
