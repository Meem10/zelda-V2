//
//  Cell.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import SwiftUI

struct Cell: View {
    
    @State var user : User
    @State var conter :Int
    
    var body: some View {
        
        HStack{
            Text("\(conter)")
                .foregroundColor(Color.white)
            
            
            if conter == 1{
                Image("Award_gold")
                    .frame(width: 10,height: 10)
                    .padding(10)
            }
            else if conter == 2 {
                Image("Awards_silver")
                    .frame(width: 10,height: 10)
                    .padding(10)
            } else if conter == 3 {
                
                Image("Awards_bronze")
                    .frame(width: 10,height: 10)
                    .padding(10)
            }
            
            // user Profile
            
            Image("\(user.profileImage)")
                .resizable()
                .frame(width: 40,height: 60)
            
            
            ZStack{
                HStack(){
                    Text("\(user.name)")
                        .foregroundColor(Color.white)
                        .font(.system(size: 15)).bold()
                    Spacer()
                    
                    HStack{
                        
                        Image("red")
                            .resizable()
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 23, height: 23)
                        
                        Text("\(user.jewelry)")
                            .font(.system(size: 12))
                        
                        
                    }
                }
            }
        }
    }
}
