//
//  SessionViewViewModel.swift
//  AquaTerra
//
//  Created by Davincci on 30/8/2023.
//

import Amplify

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionViewViewModel: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var user: AuthUser?

    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            self.user = user
            authState = .session(user: user)
            SensorListApi.shared.currentUserUsername = user.username
        } else {
            user = nil
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func signUp(username: String, email: String, password: String) {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) {[weak self]result in
            
            switch result {
            case .success(let signUpResult):
                print("Sign up result:", signUpResult)
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign Up")
                case .confirmUser(let details, _):
                    print(details ?? "No details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                }
                
                
            case .failure(let error):
                print("Sign up error:", error)
            }
            
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ) { [weak self] result in
            
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
                
            case .failure(let error):
                print("failed to confirm code: ", error)
            }
        
            
        }
    }
    
//    func login(username: String, password: String) {
//        _ = Amplify.Auth.signIn(
//            username: username,
//            password: password,
//            options: nil
//        ) {[weak self] result in
//            switch result {
//            case .success(let signInResult):
//                print(signInResult)
//                if signInResult.isSignedIn {
//                    DispatchQueue.main.async {
//                        self?.getCurrentAuthUser()
//                    }
//                }
//
//            case .failure(let error):
//                print("Login error: ", error)
//            }
//        }
//    }
    
    func login(username: String, password: String) {
        _ = Amplify.Auth.signIn(
            username: username,
            password: password,
            options: nil
        ) {[weak self] result in
            switch result {
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                    }
                }
                
            case .failure(let error):
                print("Login error: ", error)
            }
        }
    }
    
    
    func signOut() {
        _ = Amplify.Auth.signOut{ [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.user = nil
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("Sign out error: ", error)
            }
        }
    }
    
    func fetchFieldData(completion: @escaping (Result<[FieldData], Error>) -> Void) {
        SensorListApi.shared.getTopSensors { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSensorData(fieldId: String, completion: @escaping (Result<SensorDataResponse, Error>) -> Void) {
        SensorListApi.shared.getSensorData(fieldId: fieldId) { result in
            switch result {
            case .success(let sensorDataResponse):
                completion(.success(sensorDataResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
