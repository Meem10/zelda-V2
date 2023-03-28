//
//  Messages.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


class Messages:ObservableObject  {
    
    @Published var message: [Message] = []
    @Published var lastMessageId : String = ""
    @Published var chatID : String = ""
    let receiverUser : User?
    
    
    init(receiverUser:User){
        self.receiverUser = receiverUser
     
    }
    
    
     func sendMessage(text:String,senderID:String,chatID:String,receiverID:String){
        
        
      let dbRef : DatabaseReference!
         dbRef = Database.database().reference().child("Chats").child("\(self.chatID)").child("Messages").child("\(UUID())")
          dbRef.updateChildValues(["text":text,"senderID":senderID,"receiverID":receiverID,"time":"\(Date())"])
    
    }
    
     func getMessage(){
      
        
        let dbRef: DatabaseReference!
         dbRef = Database.database().reference().child("Chats").child("\(self.chatID)").child("Messages")
            dbRef.observe(.childAdded) { dataSnapshot, err in
            
            if let allMessages = dataSnapshot.value as? NSDictionary {
             
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
               let time =  dateFormater.date(from: "\(allMessages["time"] as! String)")
                
                let newMessage = Message(id: dataSnapshot.key, text: allMessages["text"] as! String, resivserID: allMessages["receiverID"] as! String, senderID: allMessages["senderID"] as! String,time: time!)
                self.message.append(newMessage)
            }
            self.message.sort {$0.time < $1.time}
            if let id = self.message.last?.id {
                self.lastMessageId = id
            }
           
        }
        
    }
    
    func check()   {
        
        var chatId = String()
        let chatDBref: DatabaseReference!
            chatDBref = Database.database().reference().child("Chats")
            chatDBref.observe(.value) { dataSnapshot , err in
            
                if let allChat = dataSnapshot.value as? NSDictionary {
                    DispatchQueue.main.async {
                        
                        
                        let allChatID = allChat.allKeys as! [String]
                        
                        for chat_ID in allChatID {
                            
                            let chatIDCOntent = chat_ID.split(separator: " ")
                           
                            if chatIDCOntent[0] == self.receiverUser!.id || chatIDCOntent[0] == Auth.auth().currentUser!.uid{
                                
                                if chatIDCOntent[1] == self.receiverUser!.id || chatIDCOntent[1] == Auth.auth().currentUser!.uid{
                                    
                                    self.chatID = chat_ID
                                    chatId = chat_ID
                                    self.message.removeAll()
                                    self.getMessage()
                                }
                                
                            }
                        }
                    }
                }
                
                if chatId == "" {
                 
                    self.chatID = "\(self.receiverUser!.id) \(Auth.auth().currentUser!.uid)"
                    self.message.removeAll()
                    self.getMessage()
                }
                
        }
    }
}


struct Message: Identifiable , Codable{
    var id : String
    var text:String
    var resivserID : String
    var senderID : String
    var time:Date
}

