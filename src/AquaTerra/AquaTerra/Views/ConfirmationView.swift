//
//  ConfirmationView.swift
//  AquaTerra
//
//  Created by Davincci on 30/8/2023.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionViewViewModel: SessionViewViewModel
    
    @State var confirmationCode = ""
    let username: String
    
    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Confirmation Code", text: $confirmationCode)
            Button("Confirm", action: {
                sessionViewViewModel.confirm(
                    username: username,
                    code: confirmationCode
                )
            })
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "David")
    }
}
