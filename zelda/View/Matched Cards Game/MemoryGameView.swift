//
//  MemoryGameView.swift
//  zelda
//
//  Created by admin on 1/16/23.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var vm = ViewModel()
    
    private var fourColumnGrid = [GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible())]
    
    private var sixColumnGrid = [GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible())]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var cards = createCardList().shuffled()
    @State var matchedCards = [GameCard]()
    @State var userChoices = [GameCard]()
    @State var winState = false
    @State var loseState = false
    @State var goHome = false
    var body: some View {
       
            GeometryReader { geo in
                        ZStack{
                            Image("background")
                                .resizable()
                                .ignoresSafeArea()
                            
                            VStack{
                                Text("Universe Memory")
                                    .foregroundColor(.white)
                                    .font(.largeTitle.monospaced().bold())
                                Text("\(vm.time)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22))
                                
                                LazyVGrid(columns: fourColumnGrid, spacing: 20){
                                    ForEach (cards){ card in
                                        CardView(card: card,
                                                 width: Int(geo.size.width/4 - 20),
                                                 matchedCards: $matchedCards,
                                                 userChoices: $userChoices)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 790)
                            
                            Text("Match these cards to win:")
                                .foregroundColor(.white)
                                .font(.title3.monospaced().bold())
                                .padding(.bottom, 98)
                            VStack{
                                    LazyVGrid(columns: sixColumnGrid, spacing: 5){
                                        ForEach(cardValues, id:\.self){ cardValue in
                                            if !matchedCards.contains(where: {$0.text == cardValue}){
                                                Image(cardValue)
                                                    .resizable()
                                                    .frame(width: geo.size.width/6 - 30 ,height: geo.size.width/6 - 30)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 40)
                                .padding(.horizontal)
                            
                            //handel end of the game option
                            if vm.isGameOver || matchedCards.count == 24{
                                if self.winState {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 320, height: 300)
                                        .cornerRadius(20)
                                        .overlay(
                                            VStack(spacing: 10){
                                                Text("You Win!!")
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
                                                    
                                                    Button {
                                                        goHome.toggle()
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
                                                
                                                //add button to go back home
                                            }).onAppear(){
                                                DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: 20, operation: "+", image: "")
                                            }
                                        .shadow(radius: 20)
                                        .padding(.bottom, 700)
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
                                                    
                                                    
                                                            Button {
                                                                goHome.toggle()
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
                                        .padding(.bottom, 700)
                                    
                                }
                            }
                        }
                    }.onAppear(){
                        vm.start(min: vm.minuts)
                            }
                    .onReceive(timer) { (_) in
                        vm.updateCountdown()
                        gameOver()
                        }
                    .fullScreenCover(isPresented: $goHome) {
                        HomeView()
                    }
           }
    
    func gameOver(){
        if matchedCards.count == 24{
            winState = true
        } else if vm.isGameOver == true{
            loseState = true
        }
    }
    }

struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView()
    }
}


extension MemoryGameView{
    final class ViewModel: ObservableObject{
        @Published var isActive = false
        @Published var isGameOver = false
        @Published var time = "2:00"
        @Published var minuts: Float = 2.0{
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
