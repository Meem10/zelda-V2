//
//  PuzzleModel.swift
//  zelda
//
//  Created by H . on 24/06/1444 AH.
//

import Foundation

struct PuzzleModel {
    
    var currentState : Bool = false
    private(set) var isGameOver = false
    private var puzzleNum = 17
    private(set) var puzzles : Array<Puzzle>
 
    init(puzzleCount : Int, createContent : (Int)-> String) {
        puzzles = Array<Puzzle>()
        
        for index in 0..<puzzleCount{
            
            let content = createContent(index)
            puzzles.append(Puzzle(id: index, content: content))
        }
        puzzles.shuffle()
//        puzzleSign()
        
    }
    
   mutating func selected(selectedPuzzle : Puzzle ){
        
        if let puzzleSpaceLocation = puzzleSpace(id: 0){
            if let puzzleSelectedLocation = puzzleSpace(id: selectedPuzzle.id){
                puzzles.swapAt(puzzleSpaceLocation, puzzleSelectedLocation)
//                puzzleSign()
            }
        }
    }
    

    
    func puzzleSpace(id : Int ) -> Int?{
        for index in puzzles.indices{
            if puzzles[index].id == id{
                return index
            }
        }
        return nil
    }
    
    mutating func puzzleSign(){
        
        for index in puzzles.indices{
            puzzles[index].isPuzzle = puzzles[index].id == index+1 ? true : false
            print("\(puzzles[index].isPuzzle)")
            currentState = puzzles[index].isPuzzle
        }
            if puzzles.filter({$0.isPuzzle == true}).count ==  puzzleNum-1 {
                isGameOver.toggle()
                print("is game over ? \(isGameOver)")

            }
        }
    
    
    struct Puzzle : Identifiable {
        var id : Int
        let content : String
        var isPuzzle : Bool = false
    }
}

