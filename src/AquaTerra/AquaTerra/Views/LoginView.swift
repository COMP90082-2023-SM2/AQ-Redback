//
//  LoginView.swift
//  AquaTerra
//
//  Created by Davincci on 26/8/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
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
                        TextField("Email Address", text: $email)
                            .textFieldStyle(DefaultTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        Button {
                            // Attemp to log in
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
                        NavigationLink("Create an Account", destination: RegisterView())
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
