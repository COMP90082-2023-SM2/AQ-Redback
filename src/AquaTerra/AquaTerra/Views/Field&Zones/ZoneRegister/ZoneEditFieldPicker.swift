//
//  ZoneEditFieldPicker.swift
//  AquaTerra
//
//  Created by WD on 2023/10/12.
//

import SwiftUI

struct ZoneEditFieldPicker: View {
    
    let title: String
    
    @State var dataSource: [Field]
    
    @Binding var selection: String
    
    var body: some View {
        
//        HStack {
//            ForEach(dataSource) { source in
//                Text(source.name)
//            }
//        }

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
//                Picker(title, selection: $selection) {
//                    ForEach(dataSource, id: \.id) { item in
//                        Text(item.name).tag(item.id)
//                            .font(.custom("OpenSans-Regular", size: 14))
//                            .foregroundColor(Color("Placeholder"))
//                            .padding([.horizontal], 30)
//                            .accentColor(Color("ButtonGradient2"))
//                    }
//                }
                .pickerStyle(.menu)
            }
            .padding(.leading, 30)
            .padding(.trailing, 20)
        }
        .frame(height: 60)
        .onAppear {
            if self.selection.isEmpty {
                self.selection = dataSource.first?.name ?? ""
            }
//            debugPrint("pick fields == \(dataSource)")
        }
    }
}

struct ZoneEditFieldPicker_Previews: PreviewProvider {
    
    static var selection : Binding<String> {
        Binding<String>(
            get: {
                return ""
            },
            set: { _ in }
        )
    }
    static var previews: some View {
        
        let fields = [Field(id: UUID().uuidString, user: "Demo", name: "Field1", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                      Field(id: UUID().uuidString, user: "Demo", name: "Field2", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil),
                      Field(id: UUID().uuidString, user: "Demo", name: "Morningt....", farm: "Farm1", crop: "Rice", soil: nil, geom: "", points: "", elevation: nil)]
        ZoneEditFieldPicker(title: "Field", dataSource: fields, selection: selection)
    }
}
