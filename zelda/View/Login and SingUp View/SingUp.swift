//
//  SingUp.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

struct SignUP : View {
    
    // MARK: States
    @State var fullName = ""
    @State var email = ""
    @State var passsword = ""
    @State var showErrorMessage = false
    @State  var errorMessage = String()
    
    // MARK: Bindings
    @Binding var index : Int
    
    var body: some View{
        
        ZStack(alignment: .bottom) {
            
            VStack{
               
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10){
                        
                        Text("Sign Up")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                        Spacer(minLength: 0)
                       
                    }
                }
                .padding(.top, 30)
                
                
                VStack{
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Color4"))
                        
                        TextField("Full Name", text: self.$fullName)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color4"))
                        
                        TextField("Email Address", text: self.$email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                
                VStack{
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color4"))
                        
                        SecureField("Password", text: self.$passsword)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("Color2"))
            .clipShape(CShapeSingUp())
            .contentShape(CShapeSingUp())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                
                self.index = 1
                
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            
            Button(action: {
                singup(name: self.fullName, email: self.email, password: self.passsword)
            }) {
                
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color3"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 1 ? 1 : 0)
        }
        .alert(isPresented: $showErrorMessage) {
            Alert(title:
                    Text("⚠️Error")
                        .foregroundColor(Color.red)
                        .font(.system(.largeTitle)),
                  message: Text("\(errorMessage)"),
                  dismissButton: .default(Text("Ok")))
                }
    }
    
    func singup(name:String,email:String,password:String){
         
        if email == "" || password == "" || name == "" {
            
            showErrorMessage = true
            errorMessage = "Please fill in all the fileds"
            
        }
        else {
            
        
        Auth.auth().createUser(withEmail: email, password: password){ authrize , err  in
            
            if err != nil {
                
                showErrorMessage = true
                errorMessage = "\(err!.localizedDescription)"
            } else {
                
                let dbRef: DatabaseReference!
                    dbRef = Database.database().reference().child("Users").child("\(authrize!.user.uid)")
                dbRef.setValue(["fullName":name,"email":email,"password":password,"profileImage":"1","jewelry":100,"type":0])
                
                guard let userID = authrize?.user.uid else { return }
                DBModel.curentUserID = userID
                
                }
            }
        }
    }
}



