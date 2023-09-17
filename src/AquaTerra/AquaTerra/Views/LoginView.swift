//
//  LoginView.swift
//  AquaTerra
//
//  Created by Davincci on 26/8/2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    
    @State var username = ""
    @State var password = ""
    
//    init(){
//        for familyName in UIFont.familyNames {
//            print(familyName)
//            for fontName in UIFont.fontNames(forFamilyName: familyName){
//                print("-- \(fontName)")
//            }
//        }
//    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    Image("Login")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 600, height: 200)
                        .offset(y:-180)
                        .mask(
                        Ellipse()
                            .foregroundColor(Color.green)
                            .frame(width: 600, height: 400)
                            .offset(y:-250)
                        )
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 76, height: 76)
                        .offset(y:-50)
                    
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                        .offset(y:-50)
                        .overlay(Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .shadow(color: Color.black.opacity(0.10), radius: 3.0, x: 0, y: 4.0)
                            .frame(width: 76, height: 76)
                            .offset(y:-50)
                            )
                    

                    
                    
               
                    Text("AquaTerra")
                        .font(.custom("OpenSans-ExtraBold", size: 20))
                        .padding(.top, 20)
                    
                }.frame(width: 300, height: 100)
                    .ignoresSafeArea()
           
                // Login Form
                VStack{
                    VStack(alignment: .center){
                        TextField("Email", text: $username)
                            .font(.custom("OpenSans-Regular", size: 14))
                            .foregroundColor(Color("Placeholder"))
                            .padding([.horizontal], 15)
                            .padding(.vertical,20)
                            .frame(height: 50)
                            .frame(width: 318)
                            .accentColor(Color("ButtonGradient2"))
                        
                    }
                    .background(Color("Hint"))
                    .cornerRadius(5)
                    .padding(5)

                    
                    VStack(alignment: .center){
                        SecureField("Password", text: $password)
                            .font(.custom("OpenSans-Regular", size: 14))
                            .foregroundColor(Color("Placeholder"))
                            .padding([.horizontal], 15)
                            .padding(.vertical,20)
                            .frame(height: 50)
                            .frame(width: 318)
                            .accentColor(Color("ButtonGradient2"))
                    }
                    .background(Color("Hint"))
                    .cornerRadius(5)
                    .padding(5)
                    
                    VStack{
                        Text("Forgot Password")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .foregroundColor(Color("ButtonGradient2"))
                            .frame(maxWidth: 318, alignment: .trailing)
                    }
                   
                    
                    VStack{
                        Button {
                        sessionViewViewModel.login(
                            username: username,
                            password: password
                        )
                    }
                    
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color("ButtonGradient1"), Color("ButtonGradient2")]), startPoint: .leading, endPoint: .trailing))
                                .frame(height: 50)
                                .frame(width: 318)
                                
                            Text("Log in")
                                .foregroundColor(Color.white)
                                .font(.custom("OpenSans-Regular", size: 16))
                                .bold()
                                .padding([.horizontal], 15)
                                .padding(.vertical,20)
                                
                            }
                        }
                    }
                
                }
                
                ZStack{
                    Divider().frame(width: 318)
                    Text("or")
                        .background(Color.white)
                        .frame(width: 30)
                        .font(.custom("OpenSans-Regular", size: 13))
                        .foregroundColor(Color.gray)
                    
                    
                }
                
                
                // Create Account
                VStack {
                    Button(action: sessionViewViewModel.showSignUp){
                        ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.black)
                            .frame(height: 50)
                            .frame(width: 318)
                        
                        Text("Create New Account")
                            .foregroundColor(Color.white)
                            .font(.custom("OpenSans-Regular", size: 16))
                            .bold()
                            .padding([.horizontal], 15)
                            .padding(.vertical,20)
                        
                            }
                    }
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
