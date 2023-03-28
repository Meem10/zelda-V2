//
//  HomeView.swift
//  zelda
//
//  Created by Munira on 14/01/2023.
//

import SwiftUI

struct HomeView: View {
    //MARK:  States
    @State var userJewerly = 0
    @State var userName = ""

    var body: some View {
        Home(userJewerly: $userJewerly,userName: $userName )
            .onAppear(){
                DispatchQueue.main.async {
                    fetchJewerly()
                }
           
        }
    }
    
    func fetchJewerly(){
        DBModel.shared.getUserInfo(id: DBModel.curentUserID) { user,error  in
            if !error  {
                userJewerly = user!.jewelry
                userName = user!.name
            }
            
        }
    }
}


struct Home: View {
    
    //MARK:  Bindings
    @Binding var userJewerly: Int
    @Binding var userName:String
    //MARK:  States
    @State var isSelectFrinsBtn = false
    @State var isSelectShopBtn = false
    @State var isSelctAccountView = false
    
    var body: some View {
   
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    //MARK:  Home Header
                    VStack {
                        HStack {
                            Text("Hi \(userName), Let's play!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack{
                                Button(action : {
                                    
                                }) {
                                    Image("red")
                                        .resizable()
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                }
                                Text("\(userJewerly)")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                                
                            }
                            .padding(.trailing)
                            .background(Color(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        //MARK:  Games
                       
                        ScrollView(.vertical, showsIndicators: false){
                            ForEach(gameList) { list in
                                VStack(spacing: 20){
                                    GameLabel(gameName: list.gameName, gameImage: list.gameImage)
                                }
                            }
                           
                        }
                    }
                }
                .overlay(
                    //MARK:  Tab Bar
                    HStack {
                        Button( action: {
                                isSelectFrinsBtn.toggle()
                            }, label : {
                                    ButtonTabBar(image: Image(systemName: "person.3.fill"))
                                    }
                                ).fullScreenCover(isPresented: $isSelectFrinsBtn) {
                                FrindsView()
                            }
                        
                        Button(action: {
                                isSelectShopBtn.toggle()
                            }, label : {
                                ButtonTabBar(image: Image("shop"))
                            }
                            ).fullScreenCover(isPresented: $isSelectShopBtn) {
                                StoreView()
                            }
                            
                        Button(action: {
                                isSelctAccountView.toggle()
                            }, label: {
                                ButtonTabBar(image: Image(systemName: "person.crop.circle"))
                            }
                        ).fullScreenCover(isPresented: $isSelctAccountView) {
                                AccountView()
                            }
                    } // tab bar
                        .padding()
                        .background(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                        .clipShape(Capsule())
                        .frame(maxWidth: 250)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    ,alignment: .bottom
                )
            }
    }
}


struct ButtonTabBar: View {
    let image : Image
    var body: some View {
        HStack{
            image
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

let gameList = [Game(id: 0, gameName: "Tic Tac Toe", gameImage: "XO"),Game(id: 1, gameName: "Puzzle", gameImage: "puzzle"),Game(id: 2, gameName: "Snake", gameImage: "snake"),Game(id: 3, gameName: "Universe Memory", gameImage: "universe"),Game(id: 4, gameName: "Ludo Star", gameImage: "ludo"),Game(id: 5, gameName: "Chess", gameImage: "chess")]

struct Game:Identifiable {
    var id: Int
    let gameName :String
    let gameImage:String
  
}
