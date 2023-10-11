//
//  WeatherRow.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 10/10/2023.
//

import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    var unit: String
    
    var body: some View {
        HStack{
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color("Hint"))
                .cornerRadius(50)
            
            Spacer()
            
            VStack(alignment:.leading,spacing: 8) {
                Text(name)
                    .font(.custom("OpenSans-SemiBold", size: 12))
                HStack{
                    Text(value)
                        .font(.custom("OpenSans-Bold", size: 25))
                    Text(unit)
                        .bold()
                        .font(.custom("OpenSans-Regular", size: 15))
                        .frame(minWidth: 15)
                }
               
            }
        }.frame(maxWidth:130)
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "thermometer", name: "Feels like", value: "8", unit:"°")
    }
}
