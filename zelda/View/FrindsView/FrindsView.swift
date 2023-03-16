//
//  FrindsView.swift
//  zelda
//
//  Created by Aamer Essa on 14/01/2023.
//

import SwiftUI

struct FrindsView: View {
    
    @ObservedObject var usersManger = Users()
    @State var showChatView = false
    @Environment(\.presentationMode) var present
   
    var body: some View {
        NavigationView {
           
            ZStack{
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        HStack {
                            Button(action : {
                                self.present.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                            Text("Zelda Player")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }.padding()
                        
                } .background(.thinMaterial)
                    
                    List{
                        
                        ForEach(0..<usersManger.users.count,id: \.self){ counter  in
                          
                            NavigationLink(destination: ChatsView(resUser: usersManger.users[counter], messagesManger: Messages(receiverUser: usersManger.users[counter])) ){
                                Cell(user: usersManger.users[counter], conter: counter+1)
                            }
                            
                        }.listRowBackground(Color.clear)
                    }.background(.clear)
                        .scrollContentBackground(.hidden)
                    
                }
               
                
            }
           
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct FrindsView_Previews: PreviewProvider {
    static var previews: some View {
        FrindsView()
    }
}
