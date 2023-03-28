//
//  StoreView.swift
//  zelda
//
//  Created by Munira on 14/01/2023.
//v

import SwiftUI

struct StoreView: View {
    @State var userJewerly = 0
    var body: some View {
        NavigationView{
            Characters(userJewerly: $userJewerly).onAppear(){
                fetchJewerly()
            }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
        
    }
    func fetchJewerly(){
        DBModel.shared.getUserInfo(id: DBModel.curentUserID) { user,error  in
            if !error {
                userJewerly = user!.jewelry
            }
        }
    }
    
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
struct Characters : View {
    @Environment(\.presentationMode) var present
    @Binding var userJewerly: Int

    var body: some View {
//        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Button(action : {
                                // pop the view when back button pressed
                                self.present.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                            Text("Zelda Store")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            HStack {
                                Button(action : {
                                    
                                }) {
                                    Image("red")
                                        .resizable()
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        
                                }
                                Text("\(userJewerly)")
                                    .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                            }
                            .padding(.trailing)
                        .background(Color(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393))
                        .cornerRadius(10)
                        } // head view
                        .padding(.horizontal)
                        .padding(.top)
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 10) {
                                ForEach(data){ i in
                                    Card(data: i, userJewerly: $userJewerly)
                                }
                            }
                            .padding(.bottom)
                        } // show cards
                      
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
//        }
    }
}
struct Card : View {
    var data : Player
    @Binding var userJewerly: Int
    var body: some View {
        HStack {
            Image(self.data.image)
                .resizable()
            .frame(width: UIScreen.main.bounds.width / 1.8)
            Spacer()
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                Image(systemName: "bolt.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        ZStack {
                            self.data.color
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 5)
                            Circle()
                                .trim(from: 0, to: self.data.power[1])
                                .stroke(Color.white, lineWidth: 5)
                        }
                            .rotationEffect(.init(degrees: -90))
                    )
                    .clipShape(Circle())
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        ZStack {
                            self.data.color
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 5)
                            Circle()
                                .trim(from: 0, to: self.data.power[2])
                                .stroke(Color.white, lineWidth: 5)
                        }
                    )
                    .clipShape(Circle())
                Image(systemName: "brain")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        ZStack {
                            self.data.color
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 5)
                            Circle()
                                .trim(from: 0, to: self.data.power[2])
                                .stroke(Color.white, lineWidth: 5)
                        }
                    )
                    .clipShape(Circle())
                Spacer(minLength: 0)
                NavigationLink(destination: Detail(userJewerly: $userJewerly , data: self.data)) {
                    Text("See Details")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25)
                        .background(Capsule().stroke(Color.white, lineWidth: 2))
                        
                }
                .offset(y: -30)
            }
            .padding(.trailing)
        }
        .frame(height: 290)
        .background(
            Color.white.opacity(0.2)
                .cornerRadius(25)
            
                .rotation3DEffect(.init(degrees: 20), axis : (x:0, y: -1, z: 0))
            // trim view
                .padding(.vertical, 35)
                .padding(.trailing, 25)
        )
        .padding(.horizontal)
    }
}

struct Detail : View {
    @Binding var userJewerly: Int
    @State private var presentAlert = false
    @State var isBuying = false
    @State var errorBuyingAlert = false
    @StateObject private var user = Users()
    
    var data : Player
    // used to pop the top most view on stack
    @Environment(\.presentationMode) var present
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(g.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                VStack {
                    ZStack {
                        HStack {
                            Button(action : {
                                // pop the view when back button pressed
                                self.present.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                            HStack {
                                Button(action : {
                                    
                                }) {
                                    Image("red")
                                        .resizable()
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 30)
                                        
                                }
                                Text("\(userJewerly)")
                                    .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                            }
                            .padding(.trailing)
                        .background(Color(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393))
                        .cornerRadius(10)
                        }
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    Image(self.data.image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 2 )
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(30)
                    Text(self.data.name)
                        .fontWeight(.bold)
                        .font(.system(size: 55))
                        .foregroundColor(.white)
                        .padding(.top)
                    HStack {
                        Button(action : {
                            
                        }) {
                            Image("red")
                                .resizable()
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 30)
                                
                        }
                        Text("\(self.data.price)")
                            .foregroundColor(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                    }
                    .padding(.trailing)
                .background(Color(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393))
                .cornerRadius(10)
//                    Text("self.data.description")
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                        .padding(.top)
                    HStack(spacing : 20){
                        Button(action : {
                            presentAlert = true

                        }) {
                            
                            if self.data.id == 0 {
                                Text(self.data.description)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                    .background(Capsule().stroke(Color.white, lineWidth: 2))
                                
                            } else {
                                if ((user.user?.character?.first(where: {$0.value == self.data.id})) != nil) {
                                    
                                    Button(action:{
                                        DBModel.shared.updateCharacter(id: DBModel.curentUserID, characterName: self.data.name)
                                        
                                    }){
                                        Text("Set as Main character")
                                            .foregroundColor(.white)
                                            .padding(.vertical)
                                            .padding(.horizontal)
                                        //                                        .frame(width: (UIScreen.main.bounds.width / 2))
                                            .background(Capsule().stroke(Color.white, lineWidth: 2))
                                    }
                                    
                                } else{
                                Text(self.data.description)
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                                    .background(Capsule().stroke(Color.white, lineWidth: 2))
                                
                                    .alert("are you sure to buy \(self.data.name)?", isPresented: $presentAlert, actions: {
                                        
                                        Button("buy", role: .cancel, action: {
                                            //check if user have enough jewerly to buy it
                                            buyCharacter(price: self.data.price, jewerly: userJewerly, image:self.data.image)
                                            
                                        })
                                        Button("Cancel", role: .destructive, action: {})
                                        
                                    }, message: {
                                        Text("")
                                    })
                                    .alert("Failed to buy", isPresented: $errorBuyingAlert, actions: {
                                        
                                    }, message: {
                                        Text("Sorry your jewerly not enough to buy \(self.data.name) :(")
                                    })
                            }
                                    }
                        
                                
                        }
                    }
                    .padding(.top)
                    Spacer()
                    
                }
                
            }
        }
    }
    
    func buyCharacter(price: Int, jewerly: Int, image: String){
        if jewerly >= price{
            self.isBuying.toggle()
            DBModel.shared.updateJewelry(id: DBModel.curentUserID, score: price, operation: "-", image: image)
            DBModel.shared.buyCharacter(id: DBModel.curentUserID, characterID: data.id)
            
        } else {
            self.errorBuyingAlert.toggle()
        }
    }
}

struct Player : Identifiable {
    let id : Int
    let power : [CGFloat]
    let image : String
    let name : String
    let color : Color
    let price : Int
    let description : String
}
var data = [Player(id: 0, power: [0.2,0.5,0.9], image: "1", name: "Sherman", color: .clear, price: 0, description: "you already have it"),
            Player(id: 1, power: [0.3,0.5,0.6], image: "luca", name: "Marty", color: .clear, price: 800, description: "buy"),
            Player(id: 2, power: [0.7,0.5,1], image: "marty", name: "Marty", color: .clear, price: 1000, description: "buy"),
            Player(id: 3, power: [0.8,0.2,1], image: "Leah", name: "Leah", color: .clear, price: 3000, description: "buy"),
            Player(id: 4, power: [1,1,1], image: "Ramos", name: "Ramos", color: .clear, price: 5000, description: "buy"),

]

