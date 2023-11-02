//
//  SensorStepView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 16/9/2023.
//

import SwiftUI
// This is edit or create sensor steps view
struct SensorStepView : View {
    var steps : [String] = ["Info","Plot","Submit"]
    @Binding var selected : Int
    
    var body: some View{
        ZStack{
            Rectangle().frame(width: 250, height: 3.5)
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

struct SensorStepView_Previews: PreviewProvider {
    @State static var c = 0
    static var previews: some View {
        SensorStepView(selected: $c)
    }
}
