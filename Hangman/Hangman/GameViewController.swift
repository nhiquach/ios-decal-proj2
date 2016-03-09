//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {


    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var hangmanStateImageView: UIImageView!
    @IBOutlet weak var phraseLabel: UILabel!
    
    var phrase: String = ""
    var correctGuesses = Set<String>()
    var incorrectGuesses = Set<String>()
    var hangmanState = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        
        setBlanks()
        incorrectGuessesLabel.text = ""
        
        loadTargets()
        
        print(phrase)
    }
    
    func setBlanks() {
        var blanks = ""
        for character in phrase.characters {
            if character != " " {
                blanks += "_ "
            } else {
                blanks += " "
            }
        }
        
        phraseLabel.text = blanks
    }
    
    
    func inputGuess() {
        if let letter = guessTextField.text {
            if letter.characters.count > 1 {
                let alertController = UIAlertController(
                    title: "Invalid Guess",
                    message: "Guesses can only be one character.",
                    preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel , handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                guessTextField.text = nil
                return
            }
            if !phrase.uppercaseString.containsString(letter.uppercaseString) {
                updateIncorrectGuesses(letter.uppercaseString)
            } else {
                updateBlanks(letter.uppercaseString)
            }
        }
        guessTextField.text = nil
        
    }
    
    func updateIncorrectGuesses(letter: String) {
        if !incorrectGuesses.contains(letter) {
            updateHangman()
        } else {
            let alertController = UIAlertController(
                title: "Invalid Guess",
                message: "Incorrect guess already made. Please try a new guess.",
                preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel , handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        incorrectGuesses.insert(letter)
        var incorrect = ""
        for letter in incorrectGuesses {
            incorrect += letter + " "
        }
        incorrectGuessesLabel.text = incorrect
        
    }
    
    func updateHangman() {
        if hangmanState >= 7 {
            return
        }
        hangmanState += 1
        let imageFileName = "hangman" + String(hangmanState) + ".gif"
        hangmanStateImageView.image = UIImage(named: imageFileName)
    }
    
    func updateBlanks(letter: String) {
        correctGuesses.insert(letter)
        
        var blanks = ""
        for character in phrase.characters {
            var blank = true
            for guess in correctGuesses {
                if guess[guess.startIndex] == character {
                    blank = false
                    blanks += guess + " "
                }
            }
            if blank == true && character != " "{
                blanks += "_ "
            }
            if character == " " {
                blanks += " "
            }
        }
        phraseLabel.text = blanks
    }
    
    func loadTargets() {
        guessButton.addTarget(self, action: "inputGuess", forControlEvents: .TouchUpInside)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
