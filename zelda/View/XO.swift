//
//  XO.swift
//  zelda
//
//  Created by Munira on 17/01/2023.
//

import SwiftUI

struct XOgame: View {
    var body: some View {
        XOButton(letter: .constant("X"))
    }
}
struct XOButton : View {
    @Binding var letter : String
    @State private var degree = 0.0
   
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                ZStack{
                    Circle()
                        .frame(width: 120,height: 120)
                        .foregroundColor(Color(red: 65/255, green: 67/255, blue: 125/255))
                    Circle()
                        .frame(width: 100,height: 100)
                        .foregroundColor(Color(red: 213/255, green: 213/255, blue: 245/255))
                    Text(letter)
                        .font(.system(size: 50)).monospaced()
                        .bold()
                        .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                }
                .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
                .simultaneousGesture(TapGesture()
                    .onEnded{ _ in
                        withAnimation(.easeIn(duration: 0.25)) {
                            self.degree -= 180
                        }
                    
                })
            }
        }
    }
}
struct Moves : View {
    @State var moves = ["","","","","","","","",""]
    @State var endGame = "Tic Tac Toe"
    @State var gameEnded = false
    @Environment(\.presentationMode) var present
    var ranges = [(0..<3),(3..<6),(6..<9)]
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
//                        HStack {
//                            Button(action : {
//                                
//                            }) {
//                                Image("red")
//                                    .resizable()
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                                    .frame(width: 30, height: 30)
//                                
//                            }
//                            Text("100")
//                                .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
//                        }
//                        .padding(.trailing)
//                        .background(Color(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393))
//                        .cornerRadius(10)
//                        .padding(.leading, 270)
                        
                            /*.alert(endGame, isPresented: $gameEnded){
                                Button( "Reset", role: .destructive, action: resetGame)
                            }*/
                        Spacer()
                            .padding()
                        Text("Tic Tac Toe")
                            .foregroundColor(.white)
                            .font(.largeTitle.monospaced().bold())
                        Spacer()
                        
                        ForEach(ranges, id: \.self) { range in
                            HStack{
                                ForEach(range, id: \.self) { i in
                                    XOButton(letter: $moves[i])
                                        .simultaneousGesture(TapGesture()
                                            .onEnded { _ in
                                                PlayerTap(index:i)
                                            })
                                }
                            }
                        }
                        Spacer()
                        HStack{
                            Button(action: resetGame, label: {
                                Text("Reset")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 25)
                                    .background(Capsule().stroke(Color.white, lineWidth: 2))
                                
                            })
                            Button(action: {
                                self.present.wrappedValue.dismiss()
                            }, label: {
                                Text("Home")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 25)
                                    .background(Capsule().stroke(Color.white, lineWidth: 2))
                            })
//                            NavigationLink(destination: HomeView()) {
//                                Text("Home")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(.white)
//                                    .padding(.vertical, 12)
//                                    .padding(.horizontal, 25)
//                                    .background(Capsule().stroke(Color.white, lineWidth: 2))
//                                
//                            }
                        }
                        
                    }
                    if gameEnded{
                        if endGame == "X has won!"{
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 320, height: 300)
                                .cornerRadius(20)
                                .overlay(
                                    VStack(spacing: 10){
                                        Text("You Win!!")
                                            .font(.largeTitle)
                                            .foregroundColor(Color.black)
                                        Image("winCharacter")
                                            .resizable()
                                            .frame(width: 70, height: 100)
                                        HStack(spacing: 0){
                                            Text("You got 10")
                                                .foregroundColor(Color.black)
                                            Image("red")
                                                .resizable()
                                                .frame(width: 25, height: 25)
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
                                                    resetGame()
                                                }
                                            
                                            Button(action: {
                                                self.present.wrappedValue.dismiss()
                                            }, label: {
                                                Rectangle()
                                                    .fill(Color(red: 12/255, green: 35/255, blue: 66/255))
                                                    .cornerRadius(15)
                                                    .frame(width: 120, height: 48)
                                                    .overlay(
                                                        Text("Home")
                                                            .font(.system(size: 13).bold())
                                                            .foregroundColor(Color.white)
                                                    )
                                                    .navigationBarBackButtonHidden(true)
                                                    .statusBar(hidden: true)
                                            }
                                            )
                                        }
                                        .padding(.top)
                                        
                                    }
                                )
                                .onAppear(){
                                        DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: 10, operation: "+", image: "")
                                    }
                               
                        } else if endGame == "O has won!"{
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 320, height: 300)
                                .cornerRadius(20)
                                .overlay(
                                    VStack(spacing: 10){
                                        Text("Sorry you lose")
                                            .font(.largeTitle)
                                            .foregroundColor(Color.black)
                                        Image("1")
                                            .resizable()
                                            .frame(width: 70, height: 100)
                                        
                                        Text("You can try again")
                                            .foregroundColor(Color.black)
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
                                                    resetGame()
                                                }
                                            
                                            
                                                    NavigationLink {
                                                        HomeView()
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
                                                            .navigationBarBackButtonHidden(true)
                                                            .statusBar(hidden: true)
                                                    }
                                                    
                                        }
                                        .padding(.top)
                                        
                                    })
                                .shadow(radius: 20)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func resetGame(){
        endGame = "Tic Tac Toe"
        gameEnded.toggle()
        moves = ["","","","","","","","",""]
    }
    func PlayerTap(index: Int){
        if moves[index] == "" {
            moves[index] = "X"
            btnMove()
        }
        for letter in ["X", "O"] {
            if checkWinner(list: moves, letter: letter) {
                endGame = "\(letter) has won!"
                gameEnded = true
                break
            }
        }
    }
    func btnMove(){
        var availbleMoves : [Int] = []
        var mpvesLeft = 0
        for move in moves {
            if move == "" {
                availbleMoves.append(mpvesLeft)
            }
            mpvesLeft += 1
        }
        if availbleMoves.count != 0 {
            moves[availbleMoves.randomElement()!] = "O"
        }
    }
}
func checkWinner(list: [String], letter: String) -> Bool{
    let winningSequences = [
    [0,1,2] , [3,4,5], [6,7,8],
    [0,4,8] , [2,4,6],
    [0,3,6] , [1,4,7], [2,5,8]
    ]
    for sequence in winningSequences {
        var score = 0
        for match in sequence {
            if list[match] == letter {
                score += 1
                if score == 3 {
                    return true
                }
            }
        }
    }
    return false
}

struct XO_Previews: PreviewProvider {
    static var previews: some View {
        Moves()
    }
}
