//
//  ForgotPassword.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
struct ForgotPassword: View {
    @State var email = ""
    @State var showMessage = false
    @State var messageContent = String()
    @State var messageType = String()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            
            ZStack{
                
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("forgotPassword")
                        .resizable()
                        .frame(width: 300,height: 300)
                    HStack{
                        Text("Forgot Password?")
                            .font(.system(.title).bold())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top,20)
                    
                    HStack{
                        Text("Don't worry just enter the email associated with your account and we'll send an email to reset your password")
                            .foregroundColor(Color.white)
                            .font(.system(.caption))
                           
                    }
                    .padding(.top,10)
                    
                        HStack{
                            Image(systemName: "envelope.fill")
                                .frame(width: 30,height: 30)
                                .foregroundColor(Color.black)
                                .padding(10)
                                
                            
                            TextField("", text: self.$email,prompt: Text("Email").foregroundColor(.gray))
                             
                                .foregroundColor(Color.black)
                                .padding(8)
                        }
                        .background(Color.white).opacity(0.8)
                        .cornerRadius(25)
                        .padding(.top,20)
                            
                    
                    HStack{
                        Button(action:{forgotPassowrd(email: self.email)}){
                            Text("Send Email")
                                .frame(maxWidth: 200)
                                .padding(5)
                                .foregroundColor(Color.black)
                                .background(Color.white)
                        }
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    .padding(.top,20)
                    Spacer()
                }
                .padding()
                
            }
            .overlay (
                
                ZStack{
                    HStack{
                        Button(action: {
                            dismiss()
                            
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.white)
                                .padding()
                            
                        })
                        Spacer()
                    }
                
                }
                   
                 
                ,alignment: .top
            )
            
            .alert(isPresented: $showMessage){
                Alert(title:
                        Text("\(messageType)")
                    .foregroundColor(Color.red)
                    .font(.system(.largeTitle)),
                      message: Text("\(messageContent)"),
                      dismissButton: .default(Text("Ok"),action: {
                    if messageType != "Error"{
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
                
            }
        }
        }
    
    func forgotPassowrd(email:String){
        if email == "" {
            messageType = "Error"
            showMessage = true
            messageContent = "Please fill all the contents "
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: email){ err in
                
                if err != nil {
                    messageType = "Error"
                    showMessage = true
                    messageContent = "\(err!.localizedDescription) "
                } else{
                    messageType = "Check Your email"
                    showMessage = true
                    messageContent = "We have sent a link to rest the password"
                }
            }
        }
        
    }

        
    }
    



struct ForgotPassword_Previews: PreviewProvider {
   
    static var previews: some View {
        
        ForgotPassword()
    }
}
