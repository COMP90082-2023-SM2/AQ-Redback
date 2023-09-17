//
//  SensorIDBar.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 16/9/2023.
//

import SwiftUI

struct SensorIDBar: View {
    @State var sensorDetail: SensorDetail?
    var colors : [Color] = [.init(hex: "#7FAF3A"),.init(hex: "#85B3A4")]
    
    var body: some View {
        HStack{
            Text("Sensor ID:").font(.custom("OpenSans-SemiBold", size: 16))
            Spacer()
            Text(sensorDetail!.sensor_id).font(.custom("OpenSans-ExtraBold", size: 16)).foregroundColor(colors[0])
            Spacer()
            Spacer()
        }.frame(height: 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .background(Color("bar"))
    }
}

