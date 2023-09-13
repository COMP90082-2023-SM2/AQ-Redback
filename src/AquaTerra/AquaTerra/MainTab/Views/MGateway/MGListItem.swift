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
        HStack{
            Text(no)
            Spacer().frame(width: 35)
            Text(gatewayId)
            Spacer()
            Image("close-circle-fill").resizable()
                .frame(width: 38,height: 38)
                .padding(.trailing,30)
                .onTapGesture {
                    deleteActionBlock?(gatewayId)
                }
        }
        .frame(height: 68)
        .padding(.leading,5)
    }
}

struct FMListItem_Previews: PreviewProvider {
    static var previews: some View {
        MGListItem()
    }
}
