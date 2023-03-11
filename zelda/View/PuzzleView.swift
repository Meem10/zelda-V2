//
//  PuzzleView.swift
//  zelda
//
//  Created by H . on 24/06/1444 AH.
//

import SwiftUI

struct PuzzleView: View {
    @StateObject private var vm = ViewModel()
    @ObservedObject var puzzelVM = PuzzleViewModel()
    @State private var gameOver = false
    @State var winState = false
    @State var loseState = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing){
                
                VStack{
                    
                    HStack(alignment: .center){
                        Text(" Puzzle Game ")
                            .font(.system(size: 35))
                            .monospaced()
                            .bold()
                            .foregroundColor(Color.white)
                        Image("puzzle")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .padding(10)
                    .background(Color(red: 21/255, green: 50/255, blue: 89/255))
                    .cornerRadius(40)
                    
                    Rectangle()
                        .fill(Color(red: 21/255, green: 50/255, blue: 89/255))
                        .cornerRadius(40)
                        .overlay(
                    Text("\(vm.time)")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                    )
                        .frame(width: 130, height: 50)
                    
                    LazyVGrid(columns : [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]){
                        ForEach(puzzelVM.puzzles){ puzzle in
                            CartView(num: puzzle.content, id: puzzle.id)
                                .cornerRadius(10)
                            //                .background(puzzelVM.puzzleModel.currentState Color.green : Color.black)
                            
                                .onTapGesture{
                                    withAnimation{
                                        puzzelVM.selected(selectedPuzzle: puzzle)
                                        puzzelVM.puzzleModel.puzzleSign()
                                        //                        print(" current state \(puzzelVM.puzzleModel.currentState)")
                                        gameOver = puzzelVM.puzzleModel.isGameOver
                                        
                                    }
                                }
                        }
                    }
                    .padding(60)
                    
                    newGameButton
                }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                    .background(Image("background") .resizable() .scaledToFill()
                        .edgesIgnoringSafeArea([.top , .bottom , .leading , .trailing]) )
                
                Image("1")
                    .resizable()
                    .frame(width: 120 , height: 180)
                    .padding(.trailing , 20)
                    .padding(.bottom , 20)
            }
            
            if vm.isGameOver || gameOver{
                if self.winState {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 320, height: 300)
                        .cornerRadius(20)
                        .overlay(
                            VStack(spacing: 10){
                                Text("You Are Genius!")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                //  .padding(.bottom,110)
                                Image("winCharacter")
                                    .resizable()
                                    .frame(width: 70, height: 100)
                                HStack(spacing: 0){
                                    Text("You got 20")
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
                                            AppState.shared.gameID = UUID()
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
                                           // .navigationBarHidden(true)
                                            .statusBar(hidden: true)
                                    }
                                    
                                }
                                .padding(.top)
                                
                                //add button to go back home
                            }).onAppear(){
                                DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: 20, operation: "+", image: "")
                            }
                        .shadow(radius: 20)
                } else if self.loseState {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 320, height: 300)
                        .cornerRadius(20)
                        .overlay(
                            VStack(spacing: 10){
                                Text("Time Over")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.black)
                                //  .padding(.bottom,110)
                                Image("1")
                                    .resizable()
                                    .frame(width: 70, height: 100)
                                
                                Text("It's ok you can try again")
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
                                            AppState.shared.gameID = UUID()
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
        }.onAppear(){
            vm.start(min: vm.minuts)
        }
        .onReceive(timer) { (_) in
            vm.updateCountdown()
            checkGameState()
        }
    }
 func checkGameState(){
    if gameOver{
        winState = true
    } else if vm.isGameOver == true{
        loseState = true
    }
}
    var newGameButton : some View {
        Button{
            withAnimation{
                puzzelVM.newGame()
            }
           
        }label:{
        Text("Shuffle")
        .padding()
        .frame(width:150, height: 30 , alignment:.center)
        .background(Color.gray.opacity(0.4))
        .foregroundColor(Color.white)
        .monospaced()
        .cornerRadius(8)
            }
    }

}



struct CartView : View {
    var num : String
    var id : Int
    
    var body : some View {
        ZStack{
        if (id != 0){
            
                Rectangle()
                    .stroke(lineWidth: 0)
                    
                Text(num)
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
            }
        } .background(Color(red: 21/255, green: 50/255, blue: 89/255))
    }
}

/*struct GameOverView : View{

    @Binding var coinsCount : Int
    var body: some View{
        GeometryReader{
            geometry in
            ZStack{
                Image("background")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment:.center){
                    Text("GameOver , 10 Coins added \n\n\nYour Coins now : \(coinsCount)")
                        .padding(40)
                        .background(Color(red: 21/255, green: 50/255, blue: 89/255))
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .monospaced()
                }
                .cornerRadius(40)
            }
        }
    }
}*/

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}

extension PuzzleView{
    final class ViewModel: ObservableObject{
        @Published var isActive = false
        @Published var isGameOver = false
        @Published var time = "1:00"
        @Published var minuts: Float = 1.0{
            didSet{
                self.time = "\(Int(minuts)):00"
            }
        }
        
        private var initialTime = 0
        private var endDate = Date()
        
        func start(min: Float){
            self.initialTime = Int(min)
            //self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(min), to: endDate)!
            
        }
        
        func updateCountdown(){
            guard isActive else { return }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0{
                self.isActive = false
                self.time = "0:00"
                self.isGameOver = true
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calender = Calendar.current
            let minutes = calender.component(.minute, from: date)
            let seconds = calender.component(.second, from: date)
            
            self.minuts = Float(minutes)
            self.time = String(format: "%d:%02d", minutes, seconds)
        }
    }
}
