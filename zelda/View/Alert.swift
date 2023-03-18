//
//  Alert.swift
//  zelda
//
//  Created by Aamer Essa on 17/03/2023.
//

import SwiftUI

struct ZeldaAlert: View {
  
    @State var isHeWins:Bool
    @State var coins:Int
    @State var goToHome = false
    
    var body: some View {
        VStack{
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 320, height: 300)
                .cornerRadius(20)
                .overlay(
                    VStack(spacing: 10){
                        Text(isHeWins ? "You Are Genius!":"Game Over!")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                       
                        Image(isHeWins ? "winCharacter" : "1")
                            .resizable()
                            .frame(width: 70, height: 100)
                        
                        HStack(spacing: 0){
                            Text(isHeWins ? "You got \(coins)":"It's ok you can try again")
                                .foregroundColor(Color.black)
                            if isHeWins{
                                Image("red")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        
                        //edit score on firebase
                        HStack(spacing: 20){
                            Rectangle()
                                .fill(Color(red: 12/255, green: 35/255, blue: 66/255))
                                .cornerRadius(15)
                                .frame(width: 120, height: 48)
                                .overlay(
                                    Text("New Game")
                                        .font(.system(size: 13).bold())
                                        .foregroundColor(Color.white)
                                ).onTapGesture {
                                    AppState.shared.gameID = UUID()
                                }
                            
                            Button {
                                goToHome.toggle()
                                
                            } label: {
                                Rectangle()
                                    .fill(Color(red: 12/255, green: 35/255, blue: 66/255))
                                    .cornerRadius(15)
                                    .frame(width: 120, height: 48)
                                    .overlay(
                                        Text("Home")
                                            .font(.system(size: 13).bold())
                                            .foregroundColor(Color.white)
                                    )
                            }
                        }
                        .padding(.top)
                    })
                        .shadow(radius: 20)
        }
        .onAppear(){
            DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: coins, operation: "+", image: "")
        }
        .fullScreenCover(isPresented: $goToHome) {
            HomeView()
        }
    }
}

