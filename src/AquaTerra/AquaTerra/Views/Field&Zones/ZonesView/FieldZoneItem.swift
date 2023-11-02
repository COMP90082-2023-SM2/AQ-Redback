//
//  FieldZoneItem.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/9.
//

import SwiftUI

struct FieldZoneItem: View {
    
    let index: Int
    
    let zone: Zone
    
    @ObservedObject var viewModel: FieldViewModel

    // Closure that handles the operation of deleting a region
    var deleteAction: ((Zone) -> Void)?

    var body: some View {
        
        ZStack {
            
                    Rectangle()
                        .fill(.white)
                        .shadow(radius: 1)
                    
                    GeometryReader { geometry in
                        VStack{
                            Spacer()
                            HStack {
                                //Display the sequence number of the area in the list
                                Text("\(index)")
                                    .font(.custom("OpenSans-Regular", size: 14))
                                    .frame(width: 30, alignment: .leading) // Fixed width
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                //Display the name of the area
                                Text(zone.name)
                                    .font(.custom("OpenSans-Regular", size: 14))
                                    .frame(width: 60, alignment: .leading) // Fixed width
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                //Display the crop information of the area (if any)
                                Text(zone.crop ?? "")
                                    .font(.custom("OpenSans-Regular", size: 14))
                                    .frame(width: 40, alignment: .leading) // Fixed width
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                HStack {
                                    // Navigation link for viewing detailed information about the area
                                    NavigationLink {
                                        ZoneDetailView(zone: zone)
                                    } label: {
                                        Image("zone_detail")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                    }
                                    
                                    // Navigation link, used to edit regional information
                                    NavigationLink {
                                        ZoneRegisterView(viewModel: viewModel, modifyType: .edit, toEditZone: zone)
                                    } label: {
                                        Image("edit")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                    }
                                    
                                    // Button for deleting areas
                                    Button {
                                        deleteZone()
                                    } label: {
                                        Image("FieldDeleteButton")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                    }
                                }
                                .frame(width: 120, alignment: .trailing) // Fixed width for the button group
                            }
                            .padding(.leading, 25)
                            .padding(.trailing, 20)
                            .frame(width: geometry.size.width) // Set the HStack's width to match the GeometryReader
                            Spacer()
                        }
                    }
                }
                .frame(height: 60)
            }

    
    func deleteZone() {
        deleteAction?(zone)
    }
}

struct FieldZoneItem_Previews: PreviewProvider {

    static var shouldDelete : Binding<Bool> {
        Binding<Bool>(
            get: {
                return true
            },
            set: { _ in }
        )
    }
    
    static var previews: some View {
        
        let zone = Zone(user: "Demo", farm: "Farm1", name: "Very long name TestZone1", field: "Field1", crop: "Rice", geom: nil, points: "", soilType25: "Loam", soilType75: "Loam", soilType125: "Loam", wiltingPoint50: 7, wiltingPoint100: 7, wiltingPoint150: 7, fieldCapacity50: 20, fieldCapacity100: 20, fieldCapacity150: 20, saturation50: 30, saturation100: 30, saturation150: 30, sensors: nil)

        FieldZoneItem(index: 0, zone: zone, viewModel: FieldViewModel.previewViewModel())
    }
}

