//
//  FieldPickerView.swift
//  AquaTerra
//
//  Created by You Zhou on 2023/10/10.
//

import SwiftUI

struct FieldPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: FieldViewModel

    @State private var pickedField: String = ""
    
    private var currentpickedField: Binding<String> {
        Binding<String>(
            get: {
                return self.pickedField
            },
            set: { self.pickedField = $0 }
        )
    }
    
    var body: some View {
        
        VStack {
            HStack{
                FMNavigationBarView(title: "Select a Field")
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
           
            
            if let fields = viewModel.fields {
                
                Divider().frame(height: 0.5)
                
                ForEach(fields, id: \.id) { field in
                    FieldPickerItem(field: field, currentPickedField: currentpickedField)
                        .frame(height: 68)
                }
                
                Spacer()
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
            pickedField = viewModel.currentFieldName
            
            print("current field: \(pickedField)")
        }
    }
    
    func selectCurrentFarm() {
        
        if !pickedField.isEmpty {
            
            viewModel.currentFieldName = pickedField
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FieldPickerView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            FieldPickerView(viewModel: FieldViewModel.previewViewModel())
        }
    }
}
