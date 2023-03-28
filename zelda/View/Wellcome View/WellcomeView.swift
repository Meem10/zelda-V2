//
//  WellcomeView.swift
//  zelda
//
//  Created by Aamer Essa on 22/03/2023.
//

import SwiftUI

struct WellcomeView: View {
    @State var currentView = 0 ;
    @State var progress : CGFloat = 0.0 ;
    var body: some View {
        ZStack{
            VStack(alignment: .center) {
                
        //MARK: - Header of the Screen
                
                HStack(spacing: 20) {
                    
                    Spacer()
                    Button(action: {
                        print("skip")
                    }, label: {
                        Text("Skip")
                            .padding(8)
                            
                    })
                    .foregroundColor(Color.black)
                    .background(Color.gray).opacity(0.2)
                    .cornerRadius(10)
                
                }
                .padding()
                .frame(maxWidth: .infinity)
                 
                
        //MARK: - Slider
                
                Spacer()
                Sliser()
                
        //MARK: - Bottom of the Screen
                
                HStack{
                    Button(action: {
                        print("next")
                    }, label: {
                        ZStack{
                            
                            Rectangle().frame(width: 100 , height: 15)
                             .opacity(0.3)
                             .foregroundColor(Color(UIColor.systemTeal))
                             .cornerRadius(15)
                            
                        }.overlay(alignment:.leading) {
                            Rectangle().frame(width: progress , height: 15)
                                .background(Color.black)
                                .cornerRadius(15)
                                
                        }
                            
                            
                    })
                    Spacer()
                    Button(action: {
                        if progress < 99 {
                            progress += 33.33
                            currentView += 1
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                    })
                }
                .padding()
            }
           
        }
    }
}

struct Sliser:View{
    var body: some View{
        VStack(alignment: .center) {
            
        
          
            // Image for the view
            Image("1")
            
            Spacer()
            
            // descreiption for the view
            Text("Welllcome to Zelda ")
                .font(.title2).bold()
            
            Spacer()
          
            
            
            
        }
    }
}

struct WellcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WellcomeView()
    }
}
