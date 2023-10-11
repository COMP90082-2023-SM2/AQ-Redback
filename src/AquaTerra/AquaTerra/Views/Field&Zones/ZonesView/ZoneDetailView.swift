//
//  ZoneDetailView.swift
//  AquaTerra
//
//  Created by WD on 2023/10/11.
//

import SwiftUI

struct ZoneDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var zone: Zone
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVStack(spacing: 0, content: {
                    
                    // Section: Zone Basic Information
                    HStack {
                        Text("Zone Basic Information")
                            .font(.custom("OpenSans-Bold", size: 16))
                            .padding(.leading, 30)
                        Spacer()
                    }
                    .frame(height: 60)
                    .background(Color(hex: "#FAFAFA"))
                    
                    Group {
                        ZoneDetailItem(title: "Farm", subTitle: zone.farm, showRightArrow: true)

                        ZoneDetailItem(title: "Field", subTitle: zone.field, showRightArrow: false)
                        
                        ZoneDetailItem(title: "Crop Type", subTitle: zone.crop ?? "", showRightArrow: true)
                        
                        Image("Soil_profile_zone")
                            .resizable()
                            .frame(width: 335, height: 217)
                            .padding(.vertical, 10)
                    }
                    
                    // Section: Soil Type, Wilting Point, Field Capacity, Saturation Point
                    HStack {
                        Text("Soil Type, Wilting Point, \nField Capacity, Saturation Point")
                            .font(.custom("OpenSans-Bold", size: 16))
                            .padding(.leading, 30)
                        Spacer()
                    }
                    .frame(height: 60)
                    .background(Color(hex: "#FAFAFA"))
                    
                    Group {
                        ZoneDetailItem(title: "Soil Type 25cm\nUnderground", subTitle: "\(zone.soilType25 ?? "")", showRightArrow: true)
                        ZoneDetailItem(title: "Soil Type 75cm\nUnderground", subTitle: "\(zone.soilType75 ?? "")", showRightArrow: true)
                        ZoneDetailItem(title: "Soil Type 125cm\nUnderground", subTitle: "\(zone.soilType125 ?? "")", showRightArrow: true)
                    }
                    Group {
                        ZoneDetailItem(title: "Wilting Point \n30-50cm", subTitle: "\(zone.wiltingPoint50 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Wilting Point \n100cm", subTitle: "\(zone.wiltingPoint100 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Wilting Point \n150cm", subTitle: "\(zone.wiltingPoint150 ?? 0)", showRightArrow: false)
                    }
                    Group {
                        ZoneDetailItem(title: "Field Capacity \n30-50cm", subTitle: "\(zone.fieldCapacity50 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Field Capacity \n100cm", subTitle: "\(zone.fieldCapacity100 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Field Capacity \n150cm", subTitle: "\(zone.fieldCapacity150 ?? 0)", showRightArrow: false)
                    }
                    Group {
                        ZoneDetailItem(title: "Saturation \nPoint 30-50cm", subTitle: "\(zone.saturation50 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Saturation \nPoint 100cm", subTitle: "\(zone.saturation100 ?? 0)", showRightArrow: false)
                        ZoneDetailItem(title: "Saturation \nPoint 150cm", subTitle: "\(zone.saturation150 ?? 0)", showRightArrow: false)
                    }
                })
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 70,height: 17)
            }
        }
        .onAppear {
            print("zone: \(zone.name)")
        }
    }
}

struct ZoneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let zone = Zone(user: "Demo", name: "Very long name TestZone1", farm: "Farm1", field: "Field1", crop: "Rice", geom: nil, points: "", soilType25: "Loam", soilType75: "Loam", soilType125: "Loam", wiltingPoint50: 7, wiltingPoint100: 7, wiltingPoint150: 7, fieldCapacity50: 20, fieldCapacity100: 20, fieldCapacity150: 20, saturation50: 30, saturation100: 30, saturation150: 30, sensors: nil)
        
        ZoneDetailView(zone: zone)
    }
}
