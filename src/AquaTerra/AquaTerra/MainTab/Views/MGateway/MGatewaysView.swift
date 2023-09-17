//
//  MyGatewaysView.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import SwiftUI

struct MGatewaysView: View {
    
    @ObservedObject private var viewModel = MGViewModel.shareInstance
    
    @State private var selectedItems : Set <Int> = []
    @State private var addGateways = false
    @State private var alertShow = false
    @State private var selectId : String = ""
    @State private var loading = false
    
    var body: some View {
        let bindingToInfoModels = Binding<[MGInfoModel]>(
            get: { self.viewModel.list },
            set: { newValue in
                self.viewModel.list = newValue
            }
        )
        
        ZStack {
            if alertShow {
                MGMainView(selectedItems: $selectedItems, addGateways: $addGateways, items: bindingToInfoModels) { id in
                    showAlert(id: id)
                }
                MGAlertView(showup: $alertShow, id: selectId,deleteActionBlock: { id in
                    deleteHandler(id: id)
                })
                    .background(.clear)
            }else{
                if loading {
                    MGMainView(selectedItems: $selectedItems, addGateways: $addGateways, items: bindingToInfoModels) { id in
                        showAlert(id: id)
                    }
                    .blendMode(.lighten)
                    .blur(radius: 5)
                    ProgressView("Loading")
                }else {
                    MGMainView(selectedItems: $selectedItems, addGateways: $addGateways, items: bindingToInfoModels) { id in
                        showAlert(id: id)
                    }
                }
            }
        }
        .background(.white)
        .onAppear{
            loading = true
            viewModel.fetchDatas({
                loading = false
            })
            BaseBarModel.share.hidden()
        }
    }
    
    private func deleteHandler(id:String){
        alertShow = false
        loading = true
        viewModel.deleteItem(id: id, complete: {
          loading = false
        })
    }
    
    private func showAlert(id:String){
        withAnimation(.easeIn,{
            alertShow = true
        })
        selectId = id
    }
}

struct MGMainView : View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedItems : Set <Int>
    @Binding var addGateways : Bool
    @Binding var items : [MGInfoModel]
    
    var deleteBlock : DeleteActionBlock?
    
    var body: some View {
        VStack{
            FMNavigationBarView(title: "My Gateways")
                .frame(height: 45)
            MGHeaderView(addGateways: $addGateways)
                .frame(maxWidth: .infinity)
            List {
                ForEach(items,id: \.self) { item in
                    MGListItem(no: item.no,gatewayId:
                        item.gatewayId,deleteActionBlock:deleteBlock)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onTapGesture {}
                }
            }
            .listStyle(PlainListStyle())
        }
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
        .navigationBarBackButtonHidden(true)
        NavigationLink("",destination: GReginstrationView(),isActive: $addGateways).opacity(0)
    }
}

struct MyGatewaysView_Previews: PreviewProvider {
    static var previews: some View {
        MGatewaysView()
    }
}
