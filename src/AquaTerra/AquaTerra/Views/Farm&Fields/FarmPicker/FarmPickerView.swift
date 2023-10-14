//
//  FarmPickerView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/9/13.
//

import SwiftUI

struct FarmPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FarmsViewModel

    @State private var pickedFarm: String = ""
    
    private var currentPickedFarm: Binding<String> {
        Binding<String>(
            get: {
                return self.pickedFarm
            },
            set: { self.pickedFarm = $0 }
        )
    }
    
    var body: some View {
        
        VStack {
            HStack{
                FMNavigationBarView(title: "Choose A Farm")
                    .frame(height: 45)
                Spacer()
                
                Button {
                    selectCurrentFarm()
                } label: {
                    Text("Select")
                        .font(.custom("OpenSans-Regular", size: 16))
                        .padding(12)
                        .foregroundColor(.white)
                        .bold()
                        .frame(width:86,height: 41)
                        .background(Color.farmNameColor)
                        .cornerRadius(5)
                        
                }.padding(.trailing, 20)
                
            }
           
            
            if let farms = viewModel.farms {
                
                Divider().frame(height: 0.5)
                
                ForEach(farms) { farm in
                    FarmPickerItem(farm: farm, currentPickedFarm: currentPickedFarm)
                        .frame(height: 68)
                }
                
                Spacer()
            } else {
                VStack {
                    Spacer()
                    
                    Image("empty")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width:50, height: 50)
                        .foregroundColor(Color.gray).opacity(0.5)
                    
                    Text("No farm yet. ").font(.custom("OpenSans-Regular", size: 13)).foregroundColor(Color.gray)
                    
                    Spacer()
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
                    }
                    .frame(width: 70,height: 17)
            }
        }
        .onAppear {
            //load from local storage
            pickedFarm = viewModel.currentFarmName
            
            print("current farm: \(pickedFarm)")
            print("current farms: \(viewModel.farms)")
        }
    }
    
    func selectCurrentFarm() {
        
        if !pickedFarm.isEmpty {
            
            viewModel.currentFarmName = pickedFarm
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FarmPickerView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            FarmPickerView(viewModel: FarmsViewModel.previewViewModel())
        }
    }
}
