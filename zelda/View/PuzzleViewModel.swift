//
//  PuzzleViewModel.swift
//  zelda
//
//  Created by H . on 24/06/1444 AH.
//

import Foundation

class PuzzleViewModel : ObservableObject
{
    private(set) var isGameOver = false
    
    static var numbers : Array<String> = ["0","1" , "2" , "3" , "4", "5" , "6" , "7" , "8","9" , "10" , "11" , "12","13" , "14" , "15" , "16"]
    
    @Published var puzzleModel : PuzzleModel
    
    
    init() {
        puzzleModel = PuzzleViewModel.createPuzzle()
    }
    
    static func createPuzzle() -> PuzzleModel{
        return PuzzleModel(puzzleCount: 17) { puzzleIndex in
            PuzzleViewModel.numbers[puzzleIndex]
        }
    }
    
    var puzzles : Array<PuzzleModel.Puzzle>{
        get{ puzzleModel.puzzles}
    }
    
    func selected(selectedPuzzle : PuzzleModel.Puzzle){
        puzzleModel.selected(selectedPuzzle: selectedPuzzle)
        
    }
    
    func newGame(){
        puzzleModel = PuzzleViewModel.createPuzzle()
    }
    
    var gameOver :Bool{
        puzzleModel.isGameOver
    }
}
