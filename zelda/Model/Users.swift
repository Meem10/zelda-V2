//
//  Users.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage


class Users : ObservableObject {
    
    @Published var users: [User] = []
    @Published var user : User?
    
    init(){
        getAllUsers()
        getUserInfo()
    }
    
    func singup(name:String,email:String,password:String){
        
        Auth.auth().createUser(withEmail: email, password: password){ authrize , err  in
            
            if err != nil {
                
            } else {
                
                let dbRef: DatabaseReference!
                    dbRef = Database.database().reference().child("Users").child("\(authrize!.user.uid)")
                    dbRef.setValue(["fullName":name,"email":email,"password":password])
            }
        }
    }
    
    func getUserInfo(){
        
        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser!.uid
            
            let dbRef :DatabaseReference!
                dbRef = Database.database().reference().child("Users").child("\(userID)")
                dbRef.observe(.value){ resualt, err  in
                
                if err != nil {
                    print("error")
                } else {
                    if let user = resualt.value as? NSDictionary {
                        
                        let newUser = User(id: userID, name: user["fullName"] as! String, email: user["email"] as! String, password: user["password"] as! String, profileImage: user["profileImage"] as! String, jewelry: user["jewelry"] as! Int,character:user["Character"] as? [String:Int],type: user["type"] as! Int)
                        
                        self.user = newUser
                       
                        
                    }
                    
                }
                
            }
        }
    }
    
    func getAllUsers(){
        if Auth.auth().currentUser != nil {
            let dbRef: DatabaseReference!
            dbRef = Database.database().reference().child("Users")
            dbRef.observe(.value) { users, err in
                self.users.removeAll()
                if let allUsers = users.value as? NSDictionary {
                    for user in allUsers {
                        if "\(user.key)" != Auth.auth().currentUser!.uid{
                            let userInfo = user.value as? NSDictionary
                            
                            let newUser = User(id: "\(user.key)", name: userInfo!["fullName"] as! String, email: userInfo!["email"] as! String, password: userInfo!["password"] as! String, profileImage: userInfo!["profileImage"] as! String, jewelry: userInfo!["jewelry"] as! Int ,type: userInfo!["type"] as! Int)
                            
                            self.users.append(newUser)
                        }
                    }
                }
                self.users.sort(by: {$0.jewelry > $1.jewelry})
               
            }
        }
        
    }
}

struct User : Codable,Identifiable {
    var id: String
    var name: String
    var email: String
    var password: String
    var profileImage :String
    var jewelry : Int
    var character :[String:Int]?
    var type:Int
}

struct DBModel{
    
    static let shared = DBModel()
    static var curentUserID = String()
    static var userJewelry = Int()
    
    func updateJewelry(id: String, score: Int, operation: String, image: String){
        
        var curentUser: User?
        
        getUserInfo(id: id) { info,error  in
            if !error  {
                curentUser = info
                DispatchQueue.main.async {
                    var totalJewelry = Int()
                    var value = [String: Any]()
                    if operation == "+"{
                        totalJewelry = score + (curentUser?.jewelry ?? 0)
                        value = ["jewelry": totalJewelry]
                    } else {
                        totalJewelry = (curentUser?.jewelry ?? 0) - score
                        value = ["profileImage": image
                                 ,"jewelry": totalJewelry]
                    }
                    if id != "" {
                        let dataREF = Database.database().reference().child("Users")
                        dataREF.child(id).updateChildValues(value)
                    }
                }
            }
        }
    }
    
    func buyCharacter(id:String,characterID:Int){
        var curentUser: User?
        getUserInfo(id: id) { info,error  in
            if !error{
                curentUser = info
                DispatchQueue.main.async{
                    //                var Character = String()
                    //                var value = [String:Int]()
                    //                value = ["CharacterID":characterID]
                    let dataREF = Database.database().reference().child("Users")
                    dataREF.child(id).child("Character").updateChildValues(["\(UUID())":characterID])
                }
            }
        }
    }
    
    func updateCharacter(id:String,characterName:String){
        
        var curentUser: User?
        getUserInfo(id: id) { info,error   in
            if !error {
                curentUser = info
                DispatchQueue.main.async{
                    //                var Character = String()
                    //                var value = [String:Int]()
                    //                value = ["CharacterID":characterID]
                    let dataREF = Database.database().reference().child("Users")
                    dataREF.child(id).updateChildValues(["profileImage":characterName])
                }
            }
        }
    }
    
    
    func getUserInfo(id: String,completion: @escaping(User?,Bool) -> Void) {
       
        var info :User?
        var error : Bool?
        let dbRef :DatabaseReference!
            dbRef = Database.database().reference().child("Users").child(id)
            dbRef.observeSingleEvent(of: .value) { (snapchot,err)  in
               
                
                if let dictionary = snapchot.value as? [String: Any] {
                    
                        info = User(id: id, name: dictionary["fullName"] as! String, email: dictionary["email"] as! String, password: dictionary["password"] as! String, profileImage: dictionary["profileImage"] as! String, jewelry: dictionary["jewelry"] as! Int, character:dictionary["Character"] as? [String:Int],type: dictionary["type"] as! Int)
                        error = false
                    
                } else {
                    info = nil
                    error = true
                }
        
                completion(info,error!)
               
            }
        }
    }
