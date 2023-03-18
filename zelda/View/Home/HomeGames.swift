//
//  HomeGames.swift
//  zelda
//
//  Created by Munira on 18/01/2023.
//

import Foundation
import SwiftUI

struct GameLabel : View {
    
     var gameName : String
     var gameImage:String
    @StateObject var appState = AppState.shared
    @State var isPresendnt = false
    
    var body: some View {
        HStack {
            HStack{
                Image(gameImage)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 4)
                    .frame(width: 50, height: 100)
                Spacer()
            } .padding(.leading, 20)
            
            Text(gameName)
                .multilineTextAlignment(.center)
                .font(.system(size: 25, design: .monospaced))
                .frame(maxWidth: 200)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
                .padding(.leading, -26)
            
            VStack(spacing: 20){
                Spacer(minLength: 0)
                HStack{
                    
                    Button(action: {
                        isPresendnt.toggle()
                    }, label: {
                        if gameName == "Ludo Star" || gameName == "Chess" {
                            Image(systemName: "lock.fill")
                                .resizable()
                                .frame(width: 12,height: 12)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 25)
                                .background(Capsule().stroke(Color.white, lineWidth: 2))
                        } else {
                            Text("Play")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 25)
                                .background(Capsule().stroke(Color.white, lineWidth: 2))
                        }
                      
                    })
                    .disabled((gameName == "Ludo Star" || gameName == "Chess") == true ? true : false)
                    .offset(x: -20, y: -50)
                    .fullScreenCover(isPresented: $isPresendnt, content: {
                        switch(gameName){
                        case "Tic Tac Toe": Moves()
                        case "Puzzle": PuzzleView().id(appState.gameID)
                        case "Snake": snake().id(appState.gameID)
                        case "Universe Memory": MemoryGameView()
                        default:
                             HomeView()
                            }
                    })
                    
//                    NavigationLink(destination:  {
//                        switch(gameName){
//                        case "Tic Tac Toe": Moves()
//                        case "Puzzle": PuzzleView().id(appState.gameID)
//                        case "Snake": snake().id(appState.gameID)
//                        case "Universe Memory": MemoryGameView()
//                        default:
//                             HomeView()
//                            }
//                        }
//                    ) {
//                        Text("Play")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 25)
//                            .background(Capsule().stroke(Color.white, lineWidth: 2))
//                    }
//                    .offset(x: -20, y: -50)
                }
            }
        }
       
        .frame(height: 200)
        .background(
            Color.white.opacity(0.2)
                .cornerRadius(25)
                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
                .padding(.vertical, 50)
                .padding(.trailing, 25)
            )
        .padding(.horizontal)
        .padding(.bottom, -90)
    }
}


//struct ThePuzzle : View {
//    @StateObject var appState = AppState.shared
//    var body: some View {
//        HStack {
//            HStack{
//                Image("puzzle")
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width / 4)
//                    .frame(width: 60, height: 100)
//                Spacer()
//            } .padding(.leading, 20)
//
//            Text("Puzzle")
//                .multilineTextAlignment(.center)
//                .font(.system(size: 25, design: .monospaced))
//                .frame(maxWidth: 200)
//                .padding(.horizontal)
//                .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
//                .padding(.leading, -26)
//            VStack(spacing: 20){
//                Spacer(minLength: 0)
//                HStack{
//                    NavigationLink(destination: PuzzleView().id(appState.gameID)) {
//                        Text("Play")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 25)
//                            .background(Capsule().stroke(Color.white, lineWidth: 2))
//                    }
//                    .offset(x: -20, y: -50)
//                }
//
//
//            }
//        }
//        .frame(height: 200)
//        .background(
//            Color.white.opacity(0.2)
//                .cornerRadius(25)
//
//                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
//            // trim view
//                .padding(.vertical, 50)
//                .padding(.trailing, 25)
//            )
//        .padding(.horizontal)
//        .padding(.bottom, -90)
//    }
//}
//struct Snake : View {
//    @StateObject var appState = AppState.shared
//    var body: some View {
//
//        HStack {
//            HStack{
//                Image("snake")
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width / 3)
//                    .frame(width: 180, height: 160)
//                    .rotation3DEffect(.init(degrees: 180), axis : (x:0, y: -1, z: 0))
//                Spacer()
//            } .padding(.leading, -50)
//
//            Text("Snake")
//                .multilineTextAlignment(.center)
//                .font(.system(size: 25, design: .monospaced))
//                .frame(maxWidth: 200)
//                .padding(.horizontal)
//                .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
//                .padding(.leading, -26)
//            VStack(spacing: 20){
//                Spacer(minLength: 0)
//                HStack{
//                    NavigationLink(destination: snake().id(appState.gameID)) {
//                        Text("Play")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 25)
//                            .background(Capsule().stroke(Color.white, lineWidth: 2))
//                    }
//                    .offset(x: -20, y: -50)
//                }
//
//
//            }
//        }
//        .frame(height: 200)
//        .background(
//            Color.white.opacity(0.2)
//                .cornerRadius(25)
//
//                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
//            // trim view
//                .padding(.vertical, 50)
//                .padding(.trailing, 25)
//            )
//        .padding(.horizontal)
//        .padding(.bottom, -90)
//    }
//}
//struct UniverseMemory : View {
//    var body: some View {
//        HStack {
//            HStack{
//                Image("universe")
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width / 3)
//                    .frame(width: 50, height: 80)
//                Spacer()
//            } .padding(.leading, 20)
//
//            Text("Universe Memory")
//                .multilineTextAlignment(.center)
//                .font(.system(size: 25, design: .monospaced))
//                .frame(maxWidth: 200)
//                .padding(.horizontal)
//                .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
//                .padding(.leading, -26)
//            VStack(spacing: 20){
//                Spacer(minLength: 0)
//                HStack{
//                    NavigationLink(destination:  MemoryGameView()) {
//                        Text("Play")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 25)
//                            .background(Capsule().stroke(Color.white, lineWidth: 2))
//                    }
//                    .offset(x: -20, y: -50)
//                }
//
//
//            }
//        }
//        .frame(height: 200)
//        .background(
//            Color.white.opacity(0.2)
//                .cornerRadius(25)
//
//                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
//            // trim view
//                .padding(.vertical, 50)
//                .padding(.trailing, 25)
//            )
//        .padding(.horizontal)
//        .padding(.bottom, -90)
//    }
//}
//
//struct Ludo : View {
//    @State private var presentAlert = false
//    var body: some View {
//        HStack {
//            HStack{
//                Image("ludo")
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width / 3)
//                    .frame(width: 50, height: 80)
////                    .rotation3DEffect(.init(degrees: 180), axis : (x:0, y: 0, z: 0))
//                Spacer()
//            } .padding(.leading, 20)
//
//            Text("Ludo Star")
//                .foregroundColor(Color.gray)
//                .multilineTextAlignment(.center)
//                .font(.system(size: 25, design: .monospaced))
//                .frame(maxWidth: 200)
//                .padding(.horizontal)
//                .shadow(color: Color.black.opacity(1), radius: 8, x: 2, y: 6)
//                .padding(.leading, -26)
//            VStack(spacing: 20){
//                Spacer(minLength: 0)
//                HStack{
//
//                    Button(action:{
//                        presentAlert = true
//                    } , label: {
//                        Text("Play")
//                           .font(.caption)
//                           .foregroundColor(Color.gray)
//                           .padding(.vertical, 12)
//                           .padding(.horizontal, 25)
//                           .background(Capsule().stroke(Color.gray, lineWidth: 2))
//
//                    })
//                    .alert("You need 3000 Jewerly to unlock", isPresented: $presentAlert, actions: {
//
//                        Button("oK", role: .cancel, action: {})
//                    }, message: {
//                        Text("")
//                    })
//                        .offset(x: -20, y: -50)
//                }
//
//
//            }
//        }
//        .frame(height: 200)
//        .background(
//            Color.white.opacity(0.2)
//                .cornerRadius(25)
//
//                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
//            // trim view
//                .padding(.vertical, 50)
//                .padding(.trailing, 25)
//            )
//        .padding(.horizontal)
//        .padding(.bottom, -90)
//    }
//
//}
//struct chess : View {
//    @State private var presentAlert = false
//    var body: some View {
//        HStack {
//            HStack{
//                Image("chess")
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width / 3)
//                    .frame(width: 50, height: 80)
////                    .rotation3DEffect(.init(degrees: 180), axis : (x:0, y: 0, z: 0))
//                Spacer()
//            } .padding(.leading, 20)
//
//            Text("Chess")
//                .foregroundColor(Color.gray)
//                .multilineTextAlignment(.center)
//                .font(.system(size: 25, design: .monospaced))
//                .frame(maxWidth: 200)
//                .padding(.horizontal)
//                .shadow(color: Color.black.opacity(1), radius: 8, x: 2, y: 6)
//                .padding(.leading, -26)
//            VStack(spacing: 20){
//                Spacer(minLength: 0)
//                HStack{
//                    Button(action:{
//                        presentAlert = true
//                    } , label: {
//                        Text("Play")
//                           .font(.caption)
//                           .foregroundColor(Color.gray)
//                           .padding(.vertical, 12)
//                           .padding(.horizontal, 25)
//                           .background(Capsule().stroke(Color.gray, lineWidth: 2))
//
//                    })
//                    .alert("You need 5000 Jewerly to unlock", isPresented: $presentAlert, actions: {
//
//                        Button("oK", role: .cancel, action: {})
//                    }, message: {
//                        Text("")
//                    })
//                        .offset(x: -20, y: -50)
//                }
//
//
//            }
//        }
//        .frame(height: 200)
//        .background(
//            Color.white.opacity(0.2)
//                .cornerRadius(25)
//
//                .rotation3DEffect(.init(degrees: 10), axis : (x:0, y: -1, z: 0))
//            // trim view
//                .padding(.vertical, 50)
//                .padding(.trailing, 25)
//            )
//        .padding(.horizontal)
//        .padding(.bottom, 110)
//    }
//
//}
