//
//  ZoneRegisterView.swift
//  AquaTerra
//
//  Created by WD on 2023/10/10.
//

import SwiftUI

struct ZoneRegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: FieldViewModel

    @State var toEditZone: Zone?

    var body: some View {
        
        let fruits: [String]? = ["Apple", "Orange", "Banana"]

        List{
            if let zones = fruits?.filter({$0.elementsEqual("Orange")}) {
                ForEach(Array(zones.enumerated()), id: \.offset) { index, fruit in
                    Text("\(index): \(fruit)").tag(index)
                }
            }
        }
    }
}

struct ZoneRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ZoneRegisterView(viewModel: FieldViewModel.previewViewModel())
    }
}
