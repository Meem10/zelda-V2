//
//  Memory.swift
//  zelda
//
//  Created by admin on 1/16/23.
//

import Foundation
import SwiftUI

class GameCard: Identifiable, ObservableObject{
    
    var id = UUID()
    @Published var isFaseUp = false
    @Published var isMatched = false
    var text: String
    
    init(text: String){
        self.text = text
    }
    
    func turnOver(){
        self.isFaseUp.toggle()
    }
}

let cardValues: [String] = ["card1","card2","card3","card4",
                  "card5","card6","card7","card8",
                  "card9","card10","card11","card12"]

func createCardList() -> [GameCard]{
    var cardList = [GameCard]()
    
    for cardValue in cardValues{
        cardList.append(GameCard(text: cardValue))
        cardList.append(GameCard(text: cardValue))
    }
    return cardList
}
