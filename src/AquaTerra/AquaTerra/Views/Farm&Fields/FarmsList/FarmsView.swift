//
//  FarmsView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
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
                FMNavigationBarView(title: "My Farm and Field").frame(height: 45)
                Divider()
                HStack {
                    Text("Current Farm: ").font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(Color.black)
                    Spacer().frame(width: 0)
                    if viewModel.currentFarm?.name == nil{
                        Text(viewModel.currentFarm?.name ?? "No Farm Yet")
                            .foregroundColor(Color.gray)
                            .font(.custom("OpenSans-SemiBold", size: 14))
                            .frame(width: 80)
                        
                    } else {
                        Text(viewModel.currentFarm?.name ?? "No Farm Yet")
                            .foregroundColor(Color("ButtonGradient2"))
                            .font(.custom("OpenSans-Bold", size: 14))
                            .frame(width: 80)
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        switchFarm()
                    } label: {
                        Text("Change")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color.farmNameColor)
                            .cornerRadius(5)
                            .bold()
                            .frame(height: 41)
                    }.navigationDestination(isPresented: $shouldPickAnotherFarm) {
                        
                        FarmPickerView(viewModel: viewModel)
                        
                    }
                    
                    Button {
                        deleteFarmAlert()
                    } label: {
                        Text("Delete")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .padding(12)
                            .foregroundColor(.white)
                            .background(Color.farmDeleteColor)
                            .cornerRadius(5)
                            .bold()
                            .frame(height: 41)
                    }
                    
                }.frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 25)
                    .padding(.trailing, 20)
                HStack {
                    Text("No.")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .padding(.leading, 30)
                    Spacer().frame(width: 43)
                    
                    Text("Field")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                    Spacer().frame(width: 50)
                    
                    Text("Crop")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                    Spacer()
                    
                    Button {
                        addNewField()
                    } label: {
                        Text("Add New Field")
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
                    .navigationDestination(isPresented: $shouldAddNewField) {
                        FarmRegisterView(viewModel: viewModel)
                    }
                }
                .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)
                .background(Color.farmHeadGreyColor)
                                
                if viewModel.currentFarm?.name == nil {
                    Spacer()
                    Image("empty")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width:50, height: 50)
                        .foregroundColor(Color.gray).opacity(0.5)
                    
                    Group {
                        Text("Please ").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray) +
                        Text("Select A Farm ").font(.custom("OpenSans-ExtraBold", size: 13)).foregroundColor(Color("HighlightColor")) +
                        Text("To Display Your Field Data").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray)
                    }.padding(.vertical,15)
                    
                    Spacer()
                } else {
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
                    }
                    
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
    
            BaseBarModel.share.hidden()

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
