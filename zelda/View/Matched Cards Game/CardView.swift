//
//  CardView.swift
//  zelda
//
//  Created by admin on 1/16/23.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var card: GameCard
    let width: Int
    @Binding var matchedCards: [GameCard]
    @Binding var userChoices: [GameCard]
    
    var body: some View {
        
                if card.isFaseUp || matchedCards.contains(where: { $0.id == card.id}) {
                    Image(card.text)
                        .resizable()
                        .padding()
                        .frame(width: CGFloat(width) ,height: CGFloat(width))
                        .background(Color(red: 213/255, green: 213/255, blue: 245/255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 65/255, green: 67/255, blue: 125/255), lineWidth:  5)
                        )
                } else {
                    Image("question")
                        .resizable()
                        .padding()
                        .frame(width: CGFloat(width) ,height: CGFloat(width))
                        .background(Color(red: 213/255, green: 213/255, blue: 245/255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 65/255, green: 67/255, blue: 125/255), lineWidth:  5)
                        )
                        .onTapGesture {
                            if userChoices.count == 0 {
                                card.turnOver()
                                userChoices.append(card)
                            } else if userChoices.count == 1{
                                card.turnOver()
                                userChoices.append(card)
                                withAnimation(Animation.linear.delay(1)){
                                    for thisCard in userChoices{
                                        thisCard.turnOver()
                                    }
                                }
                                checkForMatch()
                            }
                        }
                }
    }
    func checkForMatch(){
        if userChoices[0].text == userChoices[1].text{
            matchedCards.append(userChoices[0])
            matchedCards.append(userChoices[1])
        }
        userChoices.removeAll()
    }
}
