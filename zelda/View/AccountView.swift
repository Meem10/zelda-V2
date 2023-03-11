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
    @State var playerName = ""
    @State var playerEmail = ""
    @State var playerPassword = ""
    @State var password = ""
    @State var editingToggle = false
    @State var playerBirthDate = Date.now
    @State var playerCoins = ""
    @State var userID = "\(Auth.auth().currentUser!.uid)"
    @State var userInfo = [NSDictionary]()
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
                        self.present.wrappedValue.dismiss()
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
    }
    
     
     

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

struct infoView : View {
    @Binding var playerName : String
    @Binding var playerEmail : String
    @Binding var playerPassword : String
    @Binding var isEditingeOn : Bool
    @Binding var playerBirthDate : Date
    @Binding var playerCoins : String
    @Binding var userId : String
    @State var  successLogout  = false
    var user : User?
    var body: some View{

        ZStack(alignment: .topLeading){
            
            VStack(alignment: .leading){
            
            HStack(alignment: .center){
                Text("\(user?.name ?? "userName")")
            .font(.system(size: 30))
            //.fontDesign(.serif)
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
                }.padding(20)

            Spacer()
            
            VStack{
                ZStack(alignment: .leading){
                Image(systemName:"person")

                    TextField("", text: $playerName , prompt: Text("\(user?.name ?? "")").foregroundColor(.white.opacity(0.6))) // if the  placeeholder displayes the last stored name in db will be 👍🏻
                    .padding([.leading] , 30)
                    .disabled(!isEditingeOn)
                }.foregroundColor(.white)
                
                ZStack(alignment: .leading){
                Image(systemName:"at")
                TextField("", text: $playerEmail, prompt: Text("\(user?.email ?? "")").foregroundColor(.white.opacity(0.6)))
                    .disabled(true)
                    .padding([.leading] , 30)
                }.foregroundColor(.white)
                
                ZStack(alignment: .leading){
                Image(systemName:"staroflife.circle")
                SecureField("", text: $playerPassword, prompt: Text("\(user?.password ?? "")").foregroundColor(.white.opacity(0.6)))
                    .disabled(!isEditingeOn)
                    .padding([.leading] , 30)
                }.foregroundColor(.white)
                
                VStack(alignment: .leading){
                    DatePicker(selection: $playerBirthDate, in: ...Date.now, displayedComponents: .date){
                    Text("Select a date")
                    }.disabled(!isEditingeOn)
                    .colorInvert().colorMultiply(.white)
                        
                                    
                    Text("Your Birth day:   \(playerBirthDate.formatted(date: .long, time: .omitted))")
                    .foregroundColor(Color.white)
                                    
                    
                }.padding(.top , 30)

                Toggle("Activate Editing", isOn: $isEditingeOn)
                .foregroundColor(Color.white)
                .padding(.top , 30)
                
                
               
                
                    Button {
                        update()
                    } label: {
                        Text("Save Edition")
                            .frame(width:200, height: 30 , alignment:.center)
                            .background(Color.gray.opacity(0.4))
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }.disabled(playerName.isEmpty || playerPassword.isEmpty) // wrong opinion
                        .padding([.top] , 30)
                
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
                
            }.padding(30)
                .background(Color(red: 21/255, green: 50/255, blue: 89/255))
                .cornerRadius(40)
                
               
            }
            
            Image("\(user?.profileImage ?? "1")")
                .resizable()
                .frame(width: 100 , height: 150)
                .padding(.leading , 40)
                .padding(.top , 120)
        
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
        
        
        let currentUser = Auth.auth().currentUser
            currentUser?.updatePassword(to: playerPassword)
        
        
        let dbRef: DatabaseReference!
        dbRef = Database.database().reference().child("Users").child("\(userId)")
        
        dbRef.updateChildValues(["fullName":playerName,"email":user!.email ,"password":playerPassword,"profileImage": user!.profileImage, "jewelry": user!.jewelry ])
        
        
    }
}
