//
//  FieldZoneItem.swift
//  AquaTerra
//
//  Created by WD on 2023/10/9.
//

import SwiftUI

struct FieldZoneItem: View {
    
    let index: Int
    
    let zone: Zone
    
    @ObservedObject var viewModel: FieldViewModel
        
    @Binding var shouldShowDetail: Bool
    @Binding var shouldEdit: Bool
    @Binding var shouldDelete: Bool

//    var viewDetailAction: ((Zone) -> Void)?
//
//    var editAction: ((Zone) -> Void)?
//
//    var deleteAction: ((Zone) -> Void)?

    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(radius: 1)
            
            HStack {
                Text("\(index)")
                    .font(.custom("OpenSans-Regular", size: 14))
                Spacer().frame(width: 30)
                Text(zone.name)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .frame(maxWidth: 100)
                Spacer()
                Text(zone.crop ?? "")
                    .font(.custom("OpenSans-Regular", size: 14))
                
                Spacer()
                
                NavigationLink {
                    ZoneDetailView(zone: zone)
                } label: {
                    Image("zone_detail")
                        .resizable()
                        .frame(width: 38, height: 38)
                }
                Button {
                    editZone()
                } label: {
                    Image("edit")
                        .resizable()
                        .frame(width: 38, height: 38)
                }
//                Spacer().frame(width: 0)
                Button {
                    deleteZone()
                } label: {
                    Image("FieldDeleteButton")
                        .resizable()
                        .frame(width: 38, height: 38)
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
    
    func showZoneDetail() {
        
//        viewDetailAction?(zone)
        shouldShowDetail.toggle()
    }
    
    func editZone() {
        
//        editAction?(zone)
        shouldEdit.toggle()
    }
    
    func deleteZone() {
                
//        deleteAction?(zone)
        shouldDelete.toggle()
    }
}

struct FieldZoneItem_Previews: PreviewProvider {
    
    static var shouldShowDetail : Binding<Bool> {
        Binding<Bool>(
            get: {
                return true
            },
            set: { _ in }
        )
    }
    static var shouldEdit : Binding<Bool> {
        Binding<Bool>(
            get: {
                return true
            },
            set: { _ in }
        )
    }
    static var shouldDelete : Binding<Bool> {
        Binding<Bool>(
            get: {
                return true
            },
            set: { _ in }
        )
    }
    
    static var previews: some View {
        
        let zone = Zone(user: "Demo", name: "Very long name TestZone1", farm: "Farm1", field: "Field1", crop: "Rice", geom: nil, points: "", soilType25: "Loam", soilType75: "Loam", soilType125: "Loam", wiltingPoint50: 7, wiltingPoint100: 7, wiltingPoint150: 7, fieldCapacity50: 20, fieldCapacity100: 20, fieldCapacity150: 20, saturation50: 30, saturation100: 30, saturation150: 30, sensors: nil)

        FieldZoneItem(index: 0, zone: zone, viewModel: FieldViewModel.previewViewModel(), shouldShowDetail: shouldShowDetail, shouldEdit: shouldEdit, shouldDelete: shouldDelete)
    }
}

