//
//  FieldZonesView.swift
//  AquaTerra
//
//  Created by WD on 2023/10/9.
//

import SwiftUI

struct FieldZonesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FieldViewModel
    
    @State private var shouldPickAnotherField = false
    
    @State private var shouldAddNewZone = false
    
    @State private var shouldShowZoneDetail = false
    
    @State private var toEditZone: Zone?
    @State private var shouldShowEditZone = false
    
    @State private var toDeleteZone: Zone?
    @State private var shouldShowDeleteZoneAlert = false
    
    
    var body: some View {
        
        ZStack {
            VStack {
                FMNavigationBarView(title: "My Irrigation Zones").frame(height: 45)
                Divider()
                HStack {
                    Text("Current Field: ").font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(Color.black)
                    Spacer().frame(width: 5)
                    Text(viewModel.currentField?.name ?? "No Field Yet")
                        .foregroundColor(Color("ButtonGradient2"))
                        .font(.custom("OpenSans-Bold", size: 14))
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button {
                        pickAnotherField()
                    } label: {
                        Text("Change")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color.farmNameColor)
                            .cornerRadius(5)
                            .bold()
                            .frame(height: 41)
                    }.navigationDestination(isPresented: $shouldPickAnotherField) {
                        
                        FieldPickerView(viewModel: viewModel)
                    }
                    
                }.frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 25)
                    .padding(.trailing, 20)
                HStack {
                    Text("No.")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .padding(.leading, 20)
                    Spacer().frame(width: 43)
                    
                    Text("Zone")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                    Spacer().frame(width: 53)
                    
                    Text("Crop")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                    Spacer()
                    
                    Button {
                        addNewZone()
                    } label: {
                        Text("Add New Zone")
                            .font(.custom("OpenSans-ExtraBold", size: 14))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: Color.gradientAddButtonBackgroundColors),
                                    startPoint: .topLeading,
                                    endPoint:.bottomTrailing
                                ))
                            .cornerRadius(5)
                            .frame(height: 41)
                        
                    }
                    .ignoresSafeArea(.all)
                    .padding(.trailing, 20)
                    .padding(.vertical, 15)
                    .navigationDestination(isPresented: $shouldAddNewZone) {
                        
                        ZoneRegisterView(viewModel: viewModel)
                    }
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)
                .background(Color.farmHeadGreyColor)
                
                if let zones = viewModel.zones, let currentZones = zones.filter({$0.field.elementsEqual(viewModel.currentFieldName)}) {
                    
                    ScrollView {
                        LazyVStack(spacing: 0, content: {
                            ForEach(currentZones, id: \.id) { zone in
                                let index = currentZones.firstIndex(of: zone) ?? 0
                                FieldZoneItem(index: index, zone: zone, viewModel: viewModel, shouldShowDetail: $shouldShowZoneDetail, shouldEdit: $shouldShowEditZone, shouldDelete: $shouldShowDeleteZoneAlert)
//                                    .navigationDestination(isPresented: $shouldShowEditZone) {
//
//                                        ZoneRegisterView(viewModel: viewModel, toEditZone: zone)
//                                    }
                                    .frame(idealWidth: .infinity, maxWidth: .infinity)
                            }
                        })
                    }
                    Spacer()
                    
                } else {
                    Spacer()
                    Image("empty")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width:50, height: 50)
                        .foregroundColor(Color.gray).opacity(0.5)
                    
                    Group {
                        Text("Please ").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray) +
                        Text("Select A Field ").font(.custom("OpenSans-ExtraBold", size: 13)).foregroundColor(Color("HighlightColor")) +
                        Text("To Display Your zones").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray)
                    }.padding(.vertical,15)
                    
                    Spacer()
                    Spacer()
                }
            }
            
            if shouldShowDeleteZoneAlert {
                FarmDeleteAlert(title: "Zone Deletion", content: "Are you sure you want to delete this zone ?", showup: $shouldShowDeleteZoneAlert) {
                    
                    deleteZone()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                        BaseBarModel.share.show()
                    }
                    .frame(width: 70,height: 17)
            }
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().selectionStyle = .none
            
            viewModel.fetchFieldsAndZonesData()
        }
    }
    
    //switch another farm to show
    func pickAnotherField() {
        shouldPickAnotherField.toggle()
    }
    
    func addNewZone() {
        shouldAddNewZone.toggle()
    }
    
    func deleteZone() {
        
        guard let zone = toDeleteZone else { return }
        
        viewModel.deleteZone(zone: zone, for: viewModel.currentUserName)
        
        shouldShowDeleteZoneAlert = false
    }
}


struct FieldZonesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FieldZonesView(viewModel: FieldViewModel.previewViewModel())
        }
    }
}
