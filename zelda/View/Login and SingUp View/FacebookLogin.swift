//
//  FacebookLogin.swift
//  zelda
//
//  Created by Munira on 18/01/2023.
//

import Foundation
import SwiftUI
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

  
    struct LoginView : UIViewRepresentable {
        func makeCoordinator() -> LoginView.Coordinator {
            return LoginView.Coordinator()
        }

        func makeUIView(context: UIViewRepresentableContext<LoginView>) -> FBLoginButton {
            let button = FBLoginButton()
            button.permissions = ["email", "public_profile"]
            button.delegate = context.coordinator
            return button
        }

        func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<LoginView>) {

        }

        class Coordinator : NSObject, ObservableObject,LoginButtonDelegate{

            func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
                try! Auth.auth().signOut()
                print("Did logout")
            }

            func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

                if error != nil  {
                    print((error?.localizedDescription)!)
                    return
                }

                if AccessToken.current != nil {

                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credential) {(res ,  er) in

                        if er != nil{
                            print((er?.localizedDescription)!)
                            return
                        }

                        print("SUCCES! ")
                    }
                }
            }
        }
    }


