//
//  AquaTerraApp.swift
//  AquaTerra
//
//  Created by Davincci on 26/8/2023.
//
import Amplify
import AmplifyPlugins
import SwiftUI

@main
struct AquaTerraApp: App {
    
    @ObservedObject var sessionViewViewModel = SessionViewViewModel()
    
    init() {
        configAmplify()
        sessionViewViewModel.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionViewViewModel.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionViewViewModel)
                
            case .signUp:
                SignUpView()
                    .environmentObject(sessionViewViewModel)
                
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionViewViewModel)
                
            case .session(let user):
                SessionView(user: user)
                    .environmentObject(sessionViewViewModel)
            }
        }
    }
    
    private func configAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured successfully")
        } catch {
            print("Could not initialize Amplify", error)
        }
    }
}
