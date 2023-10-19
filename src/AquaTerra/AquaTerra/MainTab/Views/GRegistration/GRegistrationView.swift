//
//  GatewayRegistrationView.swift
//  Gateways
//
//  Created by ... on 2023/9/8.
//

import SwiftUI
import MapKit
import SimpleToast

struct GReginstrationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var seletectd = 0
    @State private var fullScreen = false
    
    @State private var textFiledText : String = ""
    
    @State private var position : CLLocationCoordinate2D?
    @State private var annotations : [MKPointAnnotation] = []
    @State private var showAlert = false
    @State private var showToast = false
    @State private var value = 0
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdropColor: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )
    
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
                            Text("Please add a marker using icon to locate your gateway on the map.")
                                .font(.custom("OpenSans-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
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
                            .padding(.top, 15)
                            .padding(.bottom, 50)
                            

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
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            HStack {
                Text("Successfully Create a Gateway!").bold()
            }
            .padding(20)
            .background(Color.green.opacity(1))
            .foregroundColor(Color.white)
            .cornerRadius(14)
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
                showToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct GReginstrationView_Previews: PreviewProvider {
    static var previews: some View {
        GReginstrationView()
    }
}
