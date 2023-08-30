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
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                VStack {
                    Text("AquaTerra")
                        .font(.system(size: 50))
                        .bold()
                    
                    // Login Form
                    Form {
                        TextField("Email Address", text: $username)
                            .textFieldStyle(DefaultTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        Button {
                            sessionViewViewModel.login(
                                username: username,
                                password: password
                            )
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.blue)
                                
                                Text("Log in")
                                    .foregroundColor(Color.white)
                                    .bold()
                            }
                        }
                        .padding(10)
                    }
                    
                    // Create Account
                    VStack {
                        Text("New to here?")
                        Button("Don't have an account? Sign Up.", action: sessionViewViewModel.showSignUp)
                    }
                    .padding(.bottom, 50)
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
