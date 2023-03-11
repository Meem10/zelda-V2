//
//  ChatsView.swift
//  zelda
//
//  Created by Aamer Essa on 14/01/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseFirestore

struct ChatsView: View {
  
    @State var resUser : User
    @State var text = ""
    @State var isFocused = true
    @StateObject var messagesManger : Messages
    @State var showTime = false
    
   
   
   
    var body: some View {
        
      
        VStack(spacing:0){
            
                VStack{
                    Title(user:resUser)
                        ScrollViewReader { proxy in
                            ScrollView{
                                getMessageView()
                                    .onChange(of: messagesManger.lastMessageId) { id in
                                        withAnimation {
                                            proxy.scrollTo(id,anchor: .bottom)
                                        }
                                        
                                    }
                            }
                        }
                    
                toolbarView()
                
            }
                .navigationBarHidden(true)
        }
        .onAppear{

                messagesManger.check()
        }
        .background(  Image("background")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all))
          
    }
    
    func getMessageView () -> some View {
        
        
        ForEach(messagesManger.message){ message in
            let isReceived = message.senderID == resUser.id
            VStack(alignment: isReceived ?.leading : .trailing){

                messageBubble(text: message.text, isResived: isReceived,messageTime: message.time)

            }
            .frame(maxWidth:.infinity,alignment: isReceived ? .leading : .trailing)
            .padding(.horizontal,15)
            .onTapGesture {
                showTime.toggle()
            }
            
        }
    }
    
    
    
    func toolbarView() -> some View {
        
        
            HStack{
                TextField("Message.....",text: $text)
                    .padding(.horizontal,10)
                    .frame(height:37)
                    .background(Color.black).opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                  
                
                Button(action: {
                    messagesManger.sendMessage(text: text, senderID: Auth.auth().currentUser!.uid, chatID: "\(resUser.id) \(Auth.auth().currentUser!.uid)", receiverID: resUser.id)
                    text = ""
                }){
                    Image("sendMessageIcon")
                        .foregroundColor(.gray)
                        .frame(width: 32,height: 32)
                        .background(
                            Circle()
                                .foregroundColor(text.isEmpty ? .gray : .blue)
                        )
                }.disabled(text.isEmpty)
            }
            .padding(.vertical,13)
            .padding(.horizontal)
            .background(.thinMaterial)
            .cornerRadius(30)
            .padding()
           
       
        
    }
    
    func messageBubble(text:String,isResived:Bool,messageTime:Date) -> some View {
        VStack{
            Text(text)
                .frame(maxWidth: 100 , alignment: isResived ? .leading : .trailing)
                .padding()
                .background(isResived ? Color.black.opacity(0.4) : .blue)
                .cornerRadius(30)
                .foregroundColor(Color.white)
            
            if showTime{
                Text("\(messageTime.formatted(.dateTime.day().month().hour().minute()))")
                    .frame(alignment: .trailing)
                    .font(.system(size: 12))
                    .padding(.bottom,5)
                    .foregroundColor(Color.white)
            }
        }
       
    }
    
}
//struct ChatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatsView()
//    }
//}
