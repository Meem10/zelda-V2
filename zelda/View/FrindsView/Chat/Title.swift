//
//  Title.swift
//  zelda
//
//  Created by Aamer Essa on 15/01/2023.
//

import SwiftUI

struct Title: View {
    
    var imageUrl = URL(string: "https://www.w3schools.com/howto/img_avatar.png")
   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var user: User
    var body: some View {
        HStack(spacing:20){
            
            VStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image("back")
                        .frame(width:30,height:30)
                }
            }
//            AsyncImage(url: imageUrl) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width:40,height: 40)
//                    .cornerRadius(50)
//            } placeholder: {
//                ProgressView()
//            }
            VStack {
                Image("\(user.profileImage)")
                    .resizable()
                    .frame(width: 60 , height: 60)
                    .padding(.leading , 40)
            }
            
            VStack(alignment: .leading){
                Text(user.name)
                    .font(.system(size: 20,design: .rounded))
                
                    
            }.frame(maxWidth:.infinity,alignment: .leading)
            

        }.padding()
            .background(.thinMaterial)
    }
}

