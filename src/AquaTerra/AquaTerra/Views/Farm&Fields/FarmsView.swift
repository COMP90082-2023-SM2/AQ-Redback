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
    
    @State private var shouldAddNewFarm = false

    var body: some View {
        
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
                    deleteFarm()
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
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)
            .background(Color.farmHeadGreyColor)
//            .padding(.horizontal)

            if let farm = viewModel.currentFarm, let fields = farm.fields {
//                List {
//                    ForEach(0..<fields.count, id: \.self) { index in
//                        FarmFieldItem(index: index, field: fields[index], viewModel: viewModel)
//                            .frame(maxWidth: .infinity)
//                    }
//                }
                let colors:[Color] = [.red,.yellow,.blue,.green,.pink,.orange]
                
                List{
                    ForEach(0..<20) { i in
                        Text("ID:\(i)")
                            .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)                    }
                }
                .background {
                    Color.white
                }
                Spacer()
                
            } else {
                Spacer()
                Text("No farm yet, try add one")
                Spacer()
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

        }
    }
    
    func addAFarm() {
        
    }
        
    //switch another farm to show
    func switchFarm() {
        shouldPickAnotherFarm.toggle()
    }
    
    func deleteFarm() {
        
    }
    
    func addNewField() {
        
        guard let farm = viewModel.currentFarm else {
            return
        }
        
        
    }
}

struct FarmsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            FarmsView(viewModel: FarmsViewModel.previewViewModel())
        }
    }
}
