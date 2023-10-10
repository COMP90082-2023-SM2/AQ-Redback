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
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color("Hint"))
                .cornerRadius(50)

            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.caption)
                    .font(.custom("OpenSans-Regular", size: 16))
                
                Text(value)
                    .bold()
                    .font(.title)
                    .font(.custom("OpenSans-Regular", size: 16))
            }
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
    }
}
