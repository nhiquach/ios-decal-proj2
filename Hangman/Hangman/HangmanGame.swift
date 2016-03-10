//
//  HangmanGame.swift
//  Hangman
//
//  Created by Nhi Quach on 3/9/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import Foundation

class HangmanGame {
    
    var phrase: String = ""
    var correctGuesses = Set<String>()
    var incorrectGuesses = Set<String>()
    var hangmanImageState = 1
    var gameOver = 0
    var winState = 0
    
    func startOver() {
        correctGuesses = Set<String>()
        incorrectGuesses = Set<String>()
        hangmanImageState = 1
        gameOver = 0
        winState = 0
    }
    
    
}