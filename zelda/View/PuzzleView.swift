//
//  PuzzleView.swift
//  zelda
//
//  Created by H . on 24/06/1444 AH.
//

import SwiftUI

struct PuzzleView: View {
    //MARK: - States
    @StateObject private var vm = ViewModel()
    @State private var gameOver = false
    @State var winState = false
    @State var loseState = false
    
    @Environment(\.presentationMode) var present
    @ObservedObject var puzzelVM = PuzzleViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func checkGameState(){
       if gameOver{
           winState = true
       } else if vm.isGameOver == true{
           loseState = true
       }
   }
    
    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing){
                
                VStack{
                    //MARK: -  The View Header
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
                       
                    //MARK: - The Game
                    LazyVGrid(columns : [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]){
                        ForEach(puzzelVM.puzzles){ puzzle in
                            CartView(num: puzzle.content, id: puzzle.id)
                                .cornerRadius(10)
                                .onTapGesture{
                                    withAnimation{
                                        puzzelVM.selected(selectedPuzzle: puzzle)
                                        puzzelVM.puzzleModel.puzzleSign()
                                        gameOver = puzzelVM.puzzleModel.isGameOver
                                        
                                    }
                                }
                            }
                        }
                            .padding(30)
                    //MARK: -  The View Bottom
                    
                    HStack{
                        Button(action: {
                            self.present.wrappedValue.dismiss()
                        }, label: {
                            Text("Home")
                                .padding()
                                .frame(width:150, height: 30 , alignment:.center)
                                .background(Color.gray.opacity(0.4))
                                .foregroundColor(Color.white)
                                .monospaced()
                                .cornerRadius(8)
                        })
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
                   
                    
                }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                    .background(Image("background") .resizable() .scaledToFill()
                        .edgesIgnoringSafeArea([.top , .bottom , .leading , .trailing]) )
            }
            
            if vm.isGameOver || gameOver{
                if self.winState{
                    ZeldaAlert(isHeWins: true, coins: 20)
                }
                else if loseState {
                    ZeldaAlert(isHeWins: false, coins: 0)
                }

            }
            
        }.onAppear(){
            vm.start(min: vm.minuts)
        }
        .onReceive(timer) { (_) in
            vm.updateCountdown()
            checkGameState()
        }
       
    } // end of body
} // end of PuzzleView



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

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}
