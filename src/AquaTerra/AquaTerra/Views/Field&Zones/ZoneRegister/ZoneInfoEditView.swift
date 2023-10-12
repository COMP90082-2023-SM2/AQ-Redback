//
//  ZoneInfoEditView.swift
//  AquaTerra
//
//  Created by WD on 2023/10/11.
//

import SwiftUI

struct ZoneInfoEditView: View {
    
    @ObservedObject var viewModel: FieldViewModel
    
    let modifyType: ZoneModifyType

    @Binding var enable: Bool
    
    private var newZoneDefaultFarm : Binding<String> {
        Binding<String>(
            get: {
                return viewModel.currentField?.farm ?? ""
            },
            set: { _ in }
        )
    }
    var clickAction: ButtonActionBlock?
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0, content: {
                    
                    if modifyType == .add { // new zone
                        
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
                            
                            ZoneInfoEditItem(title: "Farm", placeholder: "", subTitle: newZoneDefaultFarm, disabled: true, showRightArrow: false)

                            ZoneInfoPickItem(title: "Field", dataSource: viewModel.fields ?? [], selection: $viewModel.newZone.field)
                            
                            ZoneInfoEditItem(title: "Zone Name", placeholder: "Enter a zone name", subTitle: $viewModel.newZone.name, disabled: false, showRightArrow: false)
                            
                            ZoneInfoEditItem(title: "Crop Type", placeholder: "Enter a crop type", subTitle: $viewModel.newZone.crop, disabled: false, showRightArrow: false)
                            
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
                            ZoneInfoEditItem(title: "Soil Type 25cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.newZone.soilType25, disabled: false, showRightArrow: false)
                            ZoneInfoEditItem(title: "Soil Type 75cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.newZone.soilType75, disabled: false, showRightArrow: false)
                            ZoneInfoEditItem(title: "Soil Type 125cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.newZone.soilType125, disabled: false, showRightArrow: false)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Wilting Point \n30-50cm", placeholder: "Wilting point", subTitle: $viewModel.newZone.wiltingPoint50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Wilting Point \n100cm", placeholder: "Wilting point", subTitle: $viewModel.newZone.wiltingPoint100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Wilting Point \n150cm", placeholder: "Wilting point", subTitle: $viewModel.newZone.wiltingPoint150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Field Capacity \n30-50cm", placeholder: "Field fapacity", subTitle: $viewModel.newZone.fieldCapacity50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Field Capacity \n100cm", placeholder: "Field capacity", subTitle: $viewModel.newZone.fieldCapacity100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Field Capacity \n150cm", placeholder: "Field capacity", subTitle: $viewModel.newZone.fieldCapacity150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Saturation \nPoint 30-50cm", placeholder: "Saturation", subTitle: $viewModel.newZone.saturation50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Saturation \nPoint 100cm", placeholder: "Saturation", subTitle: $viewModel.newZone.saturation100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Saturation \nPoint 150cm", placeholder: "Saturation", subTitle: $viewModel.newZone.saturation150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                        
                    } else {
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
                            ZoneInfoEditItem(title: "Farm", placeholder: "", subTitle: $viewModel.editZone.farm, disabled: true, showRightArrow: false)
                            
                            ZoneInfoPickItem(title: "Field", dataSource: viewModel.fields ?? [], selection: $viewModel.editZone.field)
                            
                            ZoneInfoEditItem(title: "Zone Name", placeholder: "Enter a zone name", subTitle: $viewModel.editZone.name, disabled: false, showRightArrow: false)
                            
                            ZoneInfoEditItem(title: "Crop Type", placeholder: "Enter a crop type", subTitle: $viewModel.editZone.crop, disabled: false, showRightArrow: false)
                            
                            
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
                            ZoneInfoEditItem(title: "Soil Type 25cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.editZone.soilType25, disabled: false, showRightArrow: false)
                            ZoneInfoEditItem(title: "Soil Type 75cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.editZone.soilType75, disabled: false, showRightArrow: false)
                            ZoneInfoEditItem(title: "Soil Type 125cm\nUnderground", placeholder: "Soil type", subTitle: $viewModel.editZone.soilType125, disabled: false, showRightArrow: false)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Wilting Point \n30-50cm", placeholder: "Wilting point", subTitle: $viewModel.editZone.wiltingPoint50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Wilting Point \n100cm", placeholder: "Wilting point", subTitle: $viewModel.editZone.wiltingPoint100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Wilting Point \n150cm", placeholder: "Wilting point", subTitle: $viewModel.editZone.wiltingPoint150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Field Capacity \n30-50cm", placeholder: "Field fapacity", subTitle: $viewModel.editZone.fieldCapacity50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Field Capacity \n100cm", placeholder: "Field capacity", subTitle: $viewModel.editZone.fieldCapacity100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Field Capacity \n150cm", placeholder: "Field capacity", subTitle: $viewModel.editZone.fieldCapacity150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                        
                        Group {
                            ZoneInfoEditItem(title: "Saturation \nPoint 30-50cm", placeholder: "Saturation", subTitle: $viewModel.editZone.saturation50, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Saturation \nPoint 100cm", placeholder: "Saturation", subTitle: $viewModel.editZone.saturation100, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                            ZoneInfoEditItem(title: "Saturation \nPoint 150cm", placeholder: "Saturation", subTitle: $viewModel.editZone.saturation150, disabled: false, showRightArrow: false, keyboardType: .numberPad)
                        }
                    }
                    
                    GRButton(enable: $enable,title: "Next",buttonAction: {
                        
                        clickAction?()
                    })
                    .frame(height: 50)
                    .padding(.top)
                    
                    Spacer().frame(height: 50)
                })
            }
            .scrollDismissesKeyboard(.automatic)
            Spacer()
        }
    }
}

struct ZoneInfoEditView_Previews: PreviewProvider {
        
    static var enable : Binding<Bool> {
        Binding<Bool>(
            get: {
                return true
            },
            set: { _ in }
        )
    }
    
    static var previews: some View {
        ZoneInfoEditView(viewModel: FieldViewModel.previewViewModel(), modifyType: .add, enable: enable)
    }
}

