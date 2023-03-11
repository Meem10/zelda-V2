//
//  SplashScreen.swift
//  zelda
//
//  Created by Aamer Essa on 19/01/2023.
//

import SwiftUI

struct SplashScreen: View {
  
        @State private var isActive = false
        @State private var size = 0.8
        @State private var opacity = 0.1
        var body: some View {
            
            ZStack{
              
                Color(red: 21/255, green: 51/255, blue: 88/255).ignoresSafeArea(.all)
                
            
                
                VStack{
                    
                    Image("ZeldaLogo")
                        .resizable()
                        .frame(width:300,height:300,alignment:.center)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear(){
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
                
               
                    VStack{
                       
                        Spacer()
                        Text("Craeted By ")
                        Image("ApplLogo")
                            .resizable()
                            .frame(width:150,height:100)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .foregroundColor(Color.white)
                    .padding()
                    .onAppear(){
                        withAnimation(.easeIn(duration: 0.5)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    
                }
               

            }
            .background(Color(red: 21/255, green: 51/255, blue: 88/255)).ignoresSafeArea(.all)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation {
                        self.isActive = true
                    }
                    
                }
            }
              
        }
    
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
