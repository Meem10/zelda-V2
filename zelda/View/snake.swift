//
//  snake.swift
//  zelda
//
//  Created by admin on 1/16/23.
//

import SwiftUI


struct snake: View {
    //MARK: - Constaint
    enum direction {
        case up, down, left, right
    }
    let minX = UIScreen.main.bounds.minX + 45
    let maxX = UIScreen.main.bounds.maxX - 43
    let minY = UIScreen.main.bounds.minY + 108
    let maxY = UIScreen.main.bounds.maxY - 80
    let snakeSize:CGFloat = 12
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    //MARK: - States 
    @State var startPos:CGPoint = .zero
    @State var isStarted = true
    @State var gameOver = false
    @State var dir = direction.down
    @State var posArray = [CGPoint(x: 0, y: 0)]
    @State var foodPos = CGPoint(x: 0, y: 0)
    
    @Environment(\.presentationMode) var present
    //MARK: - View
    var body: some View {
        NavigationView {
            
            ZStack{
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                ZStack{
                    Rectangle()
                        .foregroundColor(Color(red: 213/255, green: 213/255, blue: 245/255))
                        .cornerRadius(20)
                        .padding(.top, UIScreen.main.bounds.minY + 80)
                        .padding(.bottom, UIScreen.main.bounds.maxY - 800)
                        .padding(.leading, UIScreen.main.bounds.minX + 23)
                        .padding(.trailing, UIScreen.main.bounds.maxX - 370)
                }
                .cornerRadius(30)
                
                ZStack{
                    ForEach(0..<posArray.count, id:\.self){ index in
                        //snake
                        Rectangle()
                            .fill(.black)
                            .frame(width: self.snakeSize,height: self.snakeSize)
                            .position(self.posArray[index])
                    }
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: snakeSize, height: snakeSize)
                        .position(foodPos)
                }
                
                if self.gameOver{
                    let score: Int = posArray.count - 1
                    ZeldaAlert(isHeWins: true, coins: score)
                    
                }
//                if self.gameOver {
//                   Rectangle()
//                        .fill(Color.white)
//                        .frame(width: 300, height: 280)
//                        .cornerRadius(20)
//                        .overlay(
//                            VStack(spacing: 10){
//                                Text("Game Over")
//                                    .font(.largeTitle)
//                                    .foregroundColor(Color.black)
//                                //.padding(.bottom,110)
//                                Image("3")
//                                    .resizable()
//                                    .frame(width: 70, height: 100)
//                                HStack(spacing: 0){
//                                    Text("Score \(posArray.count-1)")
//                                        .foregroundColor(.black)
//                                    Image("red")
//                                        .resizable()
//                                        .frame(width: 25, height: 25)
//                                }
//                                //edit score on firebase
//                                HStack(spacing: 20){
//                                    Rectangle()
//                                        .fill(Color(red: 12/255, green: 35/255, blue: 66/255))
//                                        .cornerRadius(15)
//                                        .frame(width: 120, height: 48)
//                                        .overlay(
//                                            Text("New Game")
//                                                .font(.system(size: 13).bold())
//                                                .foregroundColor(Color.white)
//                                        ).onTapGesture {
//
//                                            AppState.shared.gameID = UUID()
//                                        }
//
//                                    Button {
//                                        self.present.wrappedValue.dismiss()
//                                    } label: {
//                                        Rectangle()
//                                            .fill(Color(red: 12/255, green: 35/255, blue: 66/255))
//                                            .cornerRadius(15)
//                                            .frame(width: 120, height: 48)
//                                            .overlay(
//                                                Text("Home")
//                                                    .font(.system(size: 13).bold())
//                                                    .foregroundColor(Color.white)
//                                            )
//                                    }
//                                }
//                                .padding(.top)
//
//                            }).onAppear(){
//                                //edit score
//                                let score: Int = posArray.count - 1
//
//                                DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: score,operation: "+", image: "")
//                            }
//                        .shadow(radius: 20)
//
//                }
                
            }.onAppear(){
                self.foodPos = changeRecPosition()
                self.posArray[0] = changeRecPosition()
            }
            .gesture(DragGesture()
                .onChanged{ gesture in
                    if self.isStarted{
                        self.startPos = gesture.location
                        self.isStarted.toggle()
                    }
                }
                .onEnded{ gesture in
                    let xDist = abs(gesture.location.x - self.startPos.x)
                    let yDist = abs(gesture.location.y - self.startPos.y)
                    
                    if self.startPos.y < gesture.location.y && yDist > xDist{
                        self.dir = direction.down
                    } else if self.startPos.y > gesture.location.y && yDist > xDist{
                        self.dir = direction.up
                    } else if self.startPos.x > gesture.location.x && yDist < xDist{
                        self.dir = direction.right
                    } else if self.startPos.x < gesture.location.x && yDist < xDist{
                        self.dir = direction.left
                    }
                    self.isStarted.toggle()
                }
            )
            .onReceive(timer){ (_) in
                if !self.gameOver{
                    self.changeDirection()
                    if self.posArray[0] == self.foodPos {
                        self.posArray.append(self.posArray[0])
                        self.foodPos = self.changeRecPosition()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
//            .overlay (
//                Button(action: {
//                    self.present.wrappedValue.dismiss()
//                }, label: {
//                    HStack {
//                        HStack{
//                            Image(systemName: "chevron.backward")
//                                .resizable()
//                                .frame(width: 12,height: 12)
//                                .foregroundColor(Color.white)
//
//                            Text("Back")
//                                .foregroundColor(Color.white)
//                        }
//                        .padding(.leading,10)
//                        Spacer()
//                    }
//                })
//                ,alignment: .top
//            )
            
        }
        .statusBar(hidden: true)
        .navigationBarBackButtonHidden(true)
    }
    
    func changeDirection(){
        var prev = posArray[0]
        
        if self.posArray[0].x < minX || self.posArray[0].x > maxX && !gameOver{
            gameOver.toggle()
        } else if self.posArray[0].y < minY || self.posArray[0].y > maxY && !gameOver{
            gameOver.toggle()
        }
        
        if dir == .down {
            self.posArray[0].y += snakeSize
        } else if dir == .up {
            self.posArray[0].y -= snakeSize
        } else if dir == .left {
            self.posArray[0].x += snakeSize
        } else {
            self.posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
        
    }
    
    func changeRecPosition() -> CGPoint{
        let rows = Int(maxX / snakeSize)
        
        let columns = Int(maxY / snakeSize)
        
        var randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        var randomY = Int.random(in: 1..<columns) * Int(snakeSize)
        let Xmax = Int(maxX)
        let Xmin = Int(minX)
        let Ymax = Int(maxY)
        let Ymin = Int(minY)
        if randomX > Xmax {
            randomX -= Xmax
        } else if randomX < Xmin {
            randomX += Xmin
        }
        if randomY > Ymax{
            randomY -= Ymax
        } else if randomY < Ymin{
            randomY += Ymin
        }
        return CGPoint(x: randomX, y: randomY)
        
    }
}

struct snake_Previews: PreviewProvider {
    static var previews: some View {
        snake()
        
    }
}
