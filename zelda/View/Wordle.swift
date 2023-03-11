//
//  Wordle.swift
//  zelda
//
//  Created by Munira on 19/01/2023.
//

import SwiftUI

struct Wordle: View {
    var body: some View {
        WordleGame()
    }
}
struct WordleGame: View {
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct Wordle_Previews: PreviewProvider {
    static var previews: some View {
        Wordle()
    }
}
// correct : green
// misplaced : yellow
// unused : grey
// wrong : dark

extension Color {
    static var wrong : Color {
        Color(red: 0.4522017241, green: 0.4671539068, blue: 0.4754936099)
    }
    static var missPlaced : Color {
        Color(red: 0.7402648926, green: 0.676171124, blue: 0.3844127655)
    }
    static var correct : Color {
        Color(red: 0.4518285394, green: 0.632408917, blue: 0.4094463587)
    }
    static var unused : Color {
        Color(.white)
    }
    static var systemBackground : Color {
        Color(.systemBackground)
    }
}
struct GuessView : View {
    @Binding var guess : Guess
    var body: some View {
        HStack {
            ForEach(0...4, id:\.self){ index in
                Text(guess.guessLetter[index])
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .background(Color.systemBackground)
                    .font(.system(size: 35, weight: .bold))
                    .monospaced()
                    .border(Color(red: 65/255, green: 67/255, blue: 125/255))
                
            }
        }
    }
}
struct Guess {
    let index : Int
    var word = "     "
    var bgColors = [Color](repeating: .systemBackground, count: 5)
    var cardFlipped = [Bool](repeating: false, count : 5)
    var guessLetter : [String]{
        word.map { String($0)}
    }
}
class WordleDataModel : ObservableObject {
    @Published var guesses : [Guess] = []
    init(){
        newGame()
    }
    func newGame(){
        populateDefaults()
    }
    func populateDefaults() {
        guesses = []
       
        for index in 0...5 {
            guesses.append(Guess(index: index))
        }
    }
}
