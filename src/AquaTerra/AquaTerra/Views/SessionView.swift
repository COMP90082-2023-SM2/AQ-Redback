//
//  SessionView.swift
//  AquaTerra
//
//  Created by Davincci on 30/8/2023.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    let sessionViewViewModel: SessionViewViewModel
    let user: AuthUser
    
    var body: some View {
        VStack {
            Spacer()
            Text("You sign in as \(user.username) using Amplify!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Spacer()
            Button("Sign Out", action: {
                sessionViewViewModel.signOut()
            })
            Spacer()
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    static var previews: some View {
        SessionView(sessionViewViewModel: SessionViewViewModel(), user: DummyUser())
    }
}
