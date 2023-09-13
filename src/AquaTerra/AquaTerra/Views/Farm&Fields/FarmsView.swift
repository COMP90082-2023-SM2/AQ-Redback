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
                Spacer()
                Text("Field")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text("Crop")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                
                Button {
                    switchFarm()
                } label: {
                    Text("Add New Field")
                        .font(.system(size: 16))
                        .padding(12)
                        .foregroundColor(.white)
                        .background(Color.farmNameColor)
                        .cornerRadius(5)
                        .frame(height: 40)
                }
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 60)
            .background(Color.farmHeadGreyColor)
            .padding(.horizontal)
            
            if let farm = viewModel.currentFarm {
                
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
                
                Button {
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    HStack {
                        Image("arrow-left-s-fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Back")
                            .foregroundColor(.navigationTintColor)
                    }
                    .frame(width: 70)
                }
                
            }
        }
    }
    
    //switch another farm to show
    func switchFarm() {
        shouldPickAnotherFarm.toggle()
    }
    
    func deleteFarm() {
        
    }
}

struct FarmsView_Previews: PreviewProvider {
    static var previews: some View {
        FarmsView(viewModel: FarmsViewModel(currentUserName: "User Name"))
    }
}
