//
//  SignUpView.swift
//  AquaTerra
//
//  Created by Davincci on 26/8/2023.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Form {
                TextField("Username", text: $username).textFieldStyle(DefaultTextFieldStyle())
                TextField("Email", text: $email).textFieldStyle(DefaultTextFieldStyle())
                SecureField("Password", text: $password).textFieldStyle(DefaultTextFieldStyle())
                Button("Sign Up", action: {
                    sessionViewViewModel.signUp(
                        username: username,
                        email: email,
                        password: password
                    )
                })
                
                Spacer()
                Button("Already have an account?", action: {
                    sessionViewViewModel.showLogin()
                })
            }
        
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
