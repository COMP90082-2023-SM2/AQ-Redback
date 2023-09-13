//
//  GRStepView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct GRSetpView : View {
    var steps : [String] = ["ID","Position","Submit"]
    @Binding var selected : Int
    
    var body: some View{
        ZStack{
            Image("line_ic")
                .padding(.bottom)
            HStack{
                ForEach(0..<3,id: \.self){ index in
                    let complete = index < selected
                    let sel = index == selected
                    Spacer()
                    CirCleView(complete: complete,selected: sel,title: self.steps[index],index: index + 1)
                        .frame(width: 60)
                    Spacer()
                }
            }
        }
    }
}

struct GRSetpView_Previews: PreviewProvider {
    @State static var c = 0
    static var previews: some View {
        GRSetpView(selected: $c)
    }
}


struct CirCleView : View {
    var complete : Bool
    var selected = false
    var title : String
    var index : Int
    
    var body: some View{
        let backColor = selected ? Color.init(hex: "#C1B18B") : Color.black
        let bTextColor = selected ? Color.init(hex: "#C1B18B") : Color.black
        VStack {
            ZStack{
                Circle()
                    .foregroundColor(backColor)
                if !complete {
                    Text("\(index)")
                        .font(.system(size: 18,weight: .bold))
                        .foregroundColor(.white)
                }else {
                    Image("check_fill_ic")
                }
            }
            Text(title)
                .font(.system(size: 14,weight: .bold))
                .foregroundColor(bTextColor)
        }
    }
}
