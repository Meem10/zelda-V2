//
//  ContentView.swift
//  loginView
//
//  Created by mohammed alsaad on 15/01/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleSignInSwift


struct Login_signupView: View {
    var body: some View {
        
        Login_signupHomeView()
            .preferredColorScheme(.dark)
    }
}

struct login_signupView_Previews: PreviewProvider {
    static var previews: some View {
        Login_signupView()
    }
}

struct Login_signupHomeView : View {
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @State var index = 0
    
    var body: some View{
        
        NavigationView{
            
            GeometryReader{_ in
                
                VStack{
                    ZStack{
                        SignUP(index: self.$index)
                            .zIndex(Double(self.index))
 
                        Login(index: self.$index)

                    }
                   
                    
                    HStack(spacing: 15){
                        
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                            .offset(y:-150)
                        Text("OR")
                            .offset(y:-150)
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                            .offset(y:-150)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 200)
                    
                    
                    HStack(spacing: 30){
                        
                        Button(action: {
                            loginUsingGoogle()
                        }) {
                            
                            Image("google")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        .offset(y:-150)
                    }
                    .padding(.top, 30)
                }
                .padding(.vertical)
            }
            .background(Image("background").edgesIgnoringSafeArea(.all))
            .offset(y: 60)
        }
    }
    
    // MARK: - Login By Google
    
    func loginUsingGoogle(){
        
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }
           guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

                  // Create Google Sign In configuration object.
                  let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.configuration = config
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult , err in
                      
                      if err != nil {
                         print("\(err!.localizedDescription)")
                          
                      } else {
                          self.sendData(signInResult: signInResult!)
                      }
                  }
    }// loginUsingGoogle
    
    func sendData(signInResult:GIDSignInResult) {
        
        let signInResult = signInResult.user
        
            // set the data from the google
        
            let userName = "\(signInResult.profile!.givenName!) \(signInResult.profile!.familyName!)"
            let userEmail = "\(signInResult.profile!.email)"
            let userPassword = ""
    
            guard let idToken = signInResult.idToken else { return }
    
            let accessToken = signInResult.accessToken
        
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        // login
        Auth.auth().signIn(with: credential) { authResult, error in
               
            if error != nil {
                print("\(error!.localizedDescription)")
            } else {
                
                let user = User(id: authResult!.user.uid, name: userName,email: userEmail, password: userPassword, profileImage: "1",jewelry:50)
                    
                    var dbRef : DatabaseReference!
                        dbRef = Database.database().reference().child("Users").child("\(authResult!.user.uid)")
                        dbRef.setValue(["fullName":user.name,"email":user.email,"password":user.password,"profileImage":user.profileImage,"jewelry":user.jewelry])
                
                    }
                }//end Auth
            }// send sendData
} // Login_signupHomeView()


// MARK: End the login by Google

struct CShapeLogin : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
    }
}


struct CShapeSingUp : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
        }
    }
}
   
