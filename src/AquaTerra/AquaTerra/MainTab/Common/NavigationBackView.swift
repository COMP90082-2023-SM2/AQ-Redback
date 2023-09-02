//
//  NavigationBackView.swift
//  Gateways
//
//  Created by ... on 2023/9/9.
//

import SwiftUI

struct NavigationBackView : View {
    var body: some View{
        HStack(spacing:-5){
            TriangleView().frame(width: 25)
                .padding(.top,2)
            Text("Back")
                .foregroundColor(.init(hex: "#C1B18B"))
                .font(.system(size: 16,weight: .bold))
        }
    }
}

struct TriangleView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width / 2
                let height = width
                
                let p1 = CGPoint(x: 0, y: height/2)
                let p2 = CGPoint(x: width, y: 0)
                let p3 = CGPoint(x: width, y: height)
                
                path.move(to: p1)
                path.addLine(to: p2)
                path.addLine(to: p3)
                path.closeSubpath()
            }
            .fill(Color.init(hex: "#C1B18B"))
        }
    }
}

struct NavigationBackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBackView()
    }
}

