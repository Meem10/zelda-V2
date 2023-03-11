//
//  HomeView.swift
//  zelda
//
//  Created by Munira on 14/01/2023.
//

import SwiftUI

struct HomeView: View {
    @State var userJewerly = 0
    var body: some View {
        Home(userJewerly: $userJewerly ).onAppear(){
            fetchJewerly()
        }
    }
    
    func fetchJewerly(){
        DBModel.shared.getUserInfo(id: DBModel.curentUserID) { user in
            userJewerly = user.jewelry
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
      }
    }

struct Home: View {
    @Binding var userJewerly: Int

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Text("Let's play!")
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
                        } // head view
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // for side bar and the details
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 20){
                                XO()
                                ThePuzzle()
                                Snake()
                                UniverseMemory()
                                Ludo()
                                chess()
                                    .padding(.bottom, -50)
                            }
                        }
                        .padding(.bottom, -400)
                        
                        HStack {
                            // for tab bar
                            NavigationLink (
                                destination :
                                    FrindsView()
                                , label : {
                                    ButtonTabBar(image: Image(systemName: "person.3.sequence.fill")) {}
                                }
                            )
                            NavigationLink (
                                destination :
                                    StoreView().navigationBarBackButtonHidden(true)
                                , label : {
                                    ButtonTabBar(image: Image("shop")) {}
                                }
                            )
                            NavigationLink (
                                destination :
                                    AccountView().navigationBarBackButtonHidden(true)
                                , label : {
                                    ButtonTabBar(image: Image(systemName: "person.crop.circle")) {}
                                }
                            )
                            
                        } // tab bar
                        .padding()
                        .background(Color(red: 0.01332890149, green: 0.04810451716, blue:  0.1187042817))
                        .clipShape(Capsule())
                        .frame(maxWidth: 250)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.9), radius: 8, x: 2, y: 6)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct ButtonTabBar: View {
    let image : Image
    let action : () -> Void
    var body: some View {
        HStack{
            image
                .resizable()
                .frame(width: 27, height: 23)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

