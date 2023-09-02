//
//  GatewayRegistrationView.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import SwiftUI
import MapKit

struct GReginstrationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var seletectd = 0
    @State private var fullScreen = false
    
    @State private var textFiledText : String = ""
    
    @State private var position : CLLocationCoordinate2D?
    @State private var annotations : [MKPointAnnotation] = []
    
    private var isTextEmpty : Binding<Bool> {
        Binding<Bool>(
            get: {
                return !self.textFiledText.isEmpty
            },
            set: { _ in }
        )
    }
    
    private var enableBtn : Binding<Bool> {
        Binding<Bool>(
            get: {
                return position != nil
            },
            set: { _ in}
        )
    }
    
    var body: some View {
        VStack{
            if fullScreen && seletectd == 1 {
                GRMapView(fullScreen: $fullScreen,selectPosion: $position,annotations: $annotations)
            }else{
                FMNavigationBarView(title: "Gateway Registration")
                    .frame(height: 60)
                Spacer()
                    .frame(height: 20)
                VStack{
                    GRSetpView(selected: $seletectd)
                    VStack{
                        switch seletectd {
                        case 0 :
                            GRInputView(buttonClick: {
                                next()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            },textFiledText: $textFiledText, enable: isTextEmpty)
                            .padding(.top,20)
                        case 1:
                            GRMapView(fullScreen: $fullScreen,selectPosion: $position,annotations: $annotations)
                            HStack{
                                GRButton(enable:enableBtn, title: "Undo",colors: [.init(hex: "C1B18B")], buttonAction: {
                                    undo()
                                })
                                GRButton(enable:enableBtn, title: "Next") {
                                    next()
                                }
                            }
                            .frame(height: 50)
                            .padding()
                        case 2:
                            GRSubmitView(gateway: textFiledText) {
                                submit()
                            }
                            .padding(.top,20)
                        default :
                            HStack{}
                        }
                    }
                    .padding(.leading,30)
                    .padding(.trailing,30)
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackView()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 70,height: 17)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func undo() {
        position = nil
        annotations.removeAll()
    }
    
    private func next(){
        withAnimation(.linear(duration: 0.5)){
                seletectd += 1
        }
    }
    
    private func submit() {
        if let position = position {
            MGViewModel.shareInstance.submit(id: textFiledText, latitude: position.latitude,longitude: position.longitude)
            withAnimation(.linear(duration: 0.5)){
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct GReginstrationView_Previews: PreviewProvider {
    static var previews: some View {
        GReginstrationView()
    }
}
