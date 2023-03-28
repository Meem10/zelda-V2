//
//  Title.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import SwiftUI

struct Title: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var user: User
    
    var body: some View {
        HStack(spacing:20){
            
            VStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName:"chevron.left")
                        .frame(width:30,height:30)
                        .foregroundColor(Color.white)
                }
            }

            VStack {
                Image("\(user.profileImage)")
                    .resizable()
                    .frame(width: 50 , height: 50)
                    .padding(.leading , 40)
            }
            
            VStack(alignment: .leading){
                Text(user.name)
                    .font(.system(size: 20,design: .rounded))
                
            }.frame(maxWidth:.infinity,alignment: .leading)
            

        }.padding()
            
    }
}

