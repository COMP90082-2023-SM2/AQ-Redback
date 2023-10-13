//
//  ZoneEditFarmPicker.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/12.
//

import SwiftUI

struct ZoneEditFarmPicker: View {
    
    let title: String
    
    @State var dataSource: [Farm]
    
    @Binding var selection: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 0.5, x: 0, y: 0.5)
                .padding(.vertical, 1)
            HStack {
                Text(title).font(.custom("OpenSans-Regular", size: 14))
                Spacer()
                Picker(title, selection: $selection, content: {
                    ForEach(dataSource.map({$0.name}), id: \.self, content: { name in
                        Text(name)
                    })
                })
                .pickerStyle(.menu)
                .accentColor(.green)
            }
            .padding(.leading, 30)
            .padding(.trailing, 20)
        }
        .frame(height: 60)
        .onAppear {
            if self.selection.isEmpty {
                self.selection = dataSource.first?.name ?? ""
            }
            debugPrint("pick farms == \(dataSource)")
        }
    }
}

struct ZoneEditFarmPicker_Previews: PreviewProvider {
    
    static var selection : Binding<String> {
        Binding<String>(
            get: {
                return ""
            },
            set: { _ in }
        )
    }
    static var previews: some View {
        
        let farms = [Farm(user: "Demo", name: "Farm1"),
                     Farm(user: "Demo", name: "Farm2")]
        ZoneEditFarmPicker(title: "Farm", dataSource: farms, selection: selection)
    }
}
