//
//  AccountView.swift
//  zelda
//
//  Created by H . on 22/06/1444 AH.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseDatabase

struct AccountView: View {
    
    //MARK: - States
    @State var playerName = ""
    @State var playerEmail = ""
    @State var playerPassword = ""
    @State var password = ""
    @State var editingToggle = false
    @State var playerBirthDate = Date.now
    @State var playerCoins = ""
    @State var userID = "\(Auth.auth().currentUser!.uid)"
    @State var userInfo = [NSDictionary]()
    @State var backHome = false
    @StateObject private var user = Users()
    
    @Environment(\.presentationMode) var present
    
  
    var body: some View {
        
        GeometryReader{
            geometry in
            ZStack{
                Image("background")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Button(action : {
                        // pop the view when back button pressed
                        backHome.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                    } .padding(.horizontal, -180)
                    VStack {
                        infoView(playerName: $playerName, playerEmail: $playerEmail , playerPassword:  $playerPassword , isEditingeOn: $editingToggle, playerBirthDate: $playerBirthDate, playerCoins: $playerCoins,userId:$userID,user: user.user)
                    }.padding()
                }
            }
        }
        .fullScreenCover(isPresented: $backHome) {
            HomeView()
        }
    }
    
     
     

}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}

struct infoView : View {
    //MARK: - Bindings
    @Binding var playerName : String
    @Binding var playerEmail : String
    @Binding var playerPassword : String
    @Binding var isEditingeOn : Bool
    @Binding var playerBirthDate : Date
    @Binding var playerCoins : String
    @Binding var userId : String
    
    //MARK: - States
    @State var  successLogout  = false
    @State var showErrorMessage = false
    @State var errorMessage = ""
    //MARK: - Vars
    var user : User?
    var body: some View{

        ZStack(alignment: .topLeading){
            
            VStack(alignment: .leading){
            
                HStack(alignment: .center){
                    Text("\(user?.name ?? "userName")")
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                }
                    .padding(20)
                    .background(Color(red: 21/255, green: 50/255, blue: 89/255))
                    .cornerRadius(40)
            

                HStack(alignment: .center){
                    
                    Image("red")
                        .resizable()
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 23, height: 23)
                    
                    Text("\(playerCoins) \(user?.jewelry ?? 0)")
                        .foregroundColor(Color.white)
                    
                    }.padding()

                HStack{
                    //MARK: -  Profile character
                    
                    Image("\(user?.profileImage ?? "1")")
                        .resizable()
                        .frame(width: 100 , height: 150)
//                        .padding(.leading , 40)
//                        .padding(.top , 120)
                }
               
           
                VStack{
            //MARK: -  User Name
                    
                    ZStack(alignment: .leading){
                        Image(systemName:"person")

                        TextField("", text: $playerName , prompt: Text("\(user?.name ?? "")").foregroundColor(.white.opacity(0.6)))
                            .padding([.leading] , 30)
                            .disabled(!isEditingeOn)
                        
                        }.foregroundColor(.white)
                    
            //MARK: -  User Email
                    
                    ZStack(alignment: .leading){
                        Image(systemName:"at")
                        TextField("", text: $playerEmail, prompt: Text("\(user?.email ?? "")").foregroundColor(.white.opacity(0.6)))
                            .disabled(true)
                            .padding([.leading] , 30)
                        }.foregroundColor(.white)
                    
            //MARK: -  User Password
                    if playerPassword != "" && isEditingeOn {
                        ZStack(alignment: .leading){
                            Image(systemName:"lock")
                            SecureField("", text: $playerPassword, prompt: Text("\(user?.password ?? "")").foregroundColor(.white.opacity(0.6)))
                                .disabled(!isEditingeOn)
                                .padding([.leading] , 30)
                        }.foregroundColor(.white)
                    }
                    
                    if playerPassword != "" && !isEditingeOn {
                        ZStack(alignment: .leading){
                            Image(systemName:"lock")
                            TextField("\(user?.password ?? "")",text: $playerPassword).foregroundColor(.white.opacity(0.6))
                                .disabled(!isEditingeOn)
                                .padding([.leading] , 30)
                        }.foregroundColor(.white)
                    }
               
                    Toggle("Activate Editing", isOn: $isEditingeOn)
                        .foregroundColor(Color.white)
                        .padding(.top , 30)
                
            //MARK: -  Update Button
                    Button {
                        update()
                        } label: {
                            Text("Save Edition")
                                .frame(width:200, height: 30 , alignment:.center)
                                .background(Color.gray.opacity(0.4))
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                        .disabled(!isEditingeOn) // wrong opinion
                        .padding([.top] , 30)
                
            //MARK: -  Update Button
                    Button {
                        logout()
                        } label: {
                            Text("SignOut")
                                .frame(width:200, height: 30 , alignment:.center)
                                .background(Color.gray.opacity(0.4))
                                .foregroundColor(Color.red)
                                .cornerRadius(8)
                        } .fullScreenCover(isPresented: $successLogout) {
                                ContentView()
                            }
                }
                    .padding(30)
                    .background(Color(red: 21/255, green: 50/255, blue: 89/255))
                    .cornerRadius(40)
                
                Spacer()
            }
        }
        .alert(isPresented: $showErrorMessage){
            Alert(title:
                    Text("⚠️ Error")
                        .foregroundColor(Color.red)
                        .font(.system(.largeTitle)),
                  message: Text("\(errorMessage)"),
                  dismissButton: .default(Text("Ok")))

        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            DBModel.curentUserID = ""
            successLogout = true
        } catch{
            print("error")
        }
        
    }
    
    func update(){
        if playerName == "" || playerPassword == "" {
            errorMessage = "Please Fill in all the fileds!"
            showErrorMessage.toggle()
        } else {
            let currentUser = Auth.auth().currentUser
            currentUser?.updatePassword(to: playerPassword){err in
                if  err == nil {
                    
                    let dbRef: DatabaseReference!
                        dbRef = Database.database().reference().child("Users").child("\(userId)")
                        dbRef.updateChildValues(["fullName":playerName,"email":user!.email ,"password":playerPassword,"profileImage": user!.profileImage, "jewelry": user!.jewelry ]){ err , resualt  in
                        
                                if err == nil {
                                    isEditingeOn.toggle()
                                } else {
                                    showErrorMessage.toggle()
                                    errorMessage = "\(err!.localizedDescription)"
                        }
                    }
                } else {
                    errorMessage = "\(err!.localizedDescription)"
                    showErrorMessage.toggle()
                }
            }
        }
    }
}
