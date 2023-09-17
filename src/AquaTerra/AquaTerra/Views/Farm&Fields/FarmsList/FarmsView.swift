//
//  FarmsView.swift
//  AquaTerra
//
//  Created by wd on 2023/9/13.
//

import SwiftUI

struct FarmsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FarmsViewModel
    
    @State private var shouldPickAnotherFarm = false
    
    @State private var shouldAddNewField = false
    
    @State private var shouldShowDeleteFarmAlert = false
    
    @State private var deleteField: Field?
    @State private var shouldShowDeleteFieldAlert = false

    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Text("Current Farm: ")
                    Text(viewModel.currentFarm?.name ?? "No Farm Yet").foregroundColor(.farmNameColor)
                    Spacer()
                    
                    Button {
                        switchFarm()
                    } label: {
                        Text("Change")
                            .font(.system(size: 16))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color.farmNameColor)
                            .cornerRadius(5)
                    }.navigationDestination(isPresented: $shouldPickAnotherFarm) {
                        
                        FarmPickerView(viewModel: viewModel)
                    }
                    
                    Button {
                        deleteFarmAlert()
                    } label: {
                        Text("Delete")
                            .font(.system(size: 16))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color.farmDeleteColor)
                            .cornerRadius(5)
                    }
                    
                }.padding()
                
                HStack {
                    Text("No.")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.leading, 20)
                    Spacer()
                    Text("Field")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("Crop")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    
                    Button {
                        addNewField()
                    } label: {
                        Text("Add New Field")
                            .font(.system(size: 16))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: Color.gradientAddButtonBackgroundColors),
                                    startPoint: .topLeading,
                                    endPoint:.bottomTrailing
                                ))
                            .cornerRadius(5)
                            .frame(height: 40)
                        
                    }
                    .padding(.trailing, 20)
                    .navigationDestination(isPresented: $shouldAddNewField) {
                        
                        FarmRegisterView(viewModel: viewModel)
                    }
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)
                .background(Color.farmHeadGreyColor)
                .shadow(radius: 2.0,x: 0, y: 2)
                
                if let fields = viewModel.fields?.filter({$0.farm.elementsEqual(viewModel.currentFarmName)}) {
                    
                    ScrollView {
                        LazyVStack(spacing: 0, content: {
                            ForEach(0..<fields.count, id: \.self) { index in
                                FarmFieldItem(index: index, field: fields[index], viewModel: viewModel, deleteAlertShowup: $shouldShowDeleteFieldAlert, deleteAction: { field in
                                    
                                    deleteField = field
                                    shouldShowDeleteFieldAlert = true
                                    
                                }, viewDetailAction: { field in
                                    
                                    //TODO: show field detail
                                })
                                .frame(idealWidth: .infinity, maxWidth: .infinity)
                            }
                        })
                    }
                    Spacer()
                    
                } else {
                    Spacer()
                    Text((viewModel.currentFarm != nil) ? "No field yet, try add one" : "No farm yet, try add one")
                    Spacer()
                }
            }
            
            if shouldShowDeleteFarmAlert {
                FarmDeleteAlert(title: "Farm Deletion", content: "Are you sure you want to delete this farm ?", showup: $shouldShowDeleteFarmAlert) {
                    
                    deleteFarm()
                }
            }
            
            if shouldShowDeleteFieldAlert {
                FarmDeleteAlert(title: "Field Deletion", content: "Are you sure you want to delete this field ?", showup: $shouldShowDeleteFieldAlert) {
                    
                    deleteFieldData()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("My Farms and Fields")
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
            
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().selectionStyle = .none
            
            viewModel.fetchFarmsAndFieldsData()
        }
    }
    
    func addNewField() {
        shouldAddNewField.toggle()
    }
    
    //switch another farm to show
    func switchFarm() {
        shouldPickAnotherFarm.toggle()
    }
    
    func deleteFarmAlert() {
        shouldShowDeleteFarmAlert = true
    }
    
    func deleteFarm() {
        
        guard let farm = viewModel.currentFarm else { return }
        
        viewModel.deleteFarm(farm: farm)
        
        shouldShowDeleteFarmAlert = false
    }
    
    func deleteFieldAlert() {
        shouldShowDeleteFarmAlert = true
    }
    
    func deleteFieldData() {
        
        guard let field = deleteField else { return }
                
        viewModel.deleteField(field: field)
        
        shouldShowDeleteFieldAlert = false
    }
}

struct FarmsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            FarmsView(viewModel: FarmsViewModel.previewViewModel())
        }
    }
}
