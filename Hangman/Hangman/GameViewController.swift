//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var startOverButton: UIBarButtonItem!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var hangmanStateImageView: UIImageView!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    
    let hangmanPhrases = HangmanPhrases()
    var hangmanGame: HangmanGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 169.0/255, green: 213.0/255, blue: 198.0/255, alpha: 1.0)
        // Do any additional setup after loading the view.
        newGame()
        loadTargets()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        guessTextField.resignFirstResponder()
    }
    
    func startOver() {
        hangmanGame!.startOver()
        cleanView()
    }
    
    func newGame() {
        hangmanGame = HangmanGame()
        hangmanGame!.phrase = hangmanPhrases.getRandomPhrase()
        cleanView()
        print(hangmanGame!.phrase)
    }
    
    func cleanView() {
        setBlanks()
        incorrectGuessesLabel.text = ""
        let imageFileName = "hangman" + String(hangmanGame!.hangmanImageState) + ".png"
        hangmanStateImageView.image = UIImage(named: imageFileName)
    }
    
    func setBlanks() {
        var blanks = ""
        for character in hangmanGame!.phrase.characters {
            if character != " " {
                blanks += "_ "
            } else {
                blanks += " "
            }
        }
        phraseLabel.text = blanks
    }
    
    
    func inputGuess() {
        if hangmanGame!.gameOver == 0 {
            if let letter = guessTextField.text {
                if letter.characters.count > 1 || letter == "" {
                    let alertController = UIAlertController(
                        title: "Invalid Guess",
                        message: "Guesses are limited to one character.",
                        preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel , handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    guessTextField.text = nil
                    return
                }
                let chr = letter.characters.first
                if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                    let alertController = UIAlertController(
                        title: "Invalid Guess",
                        message: "Guesses can only be one alphabetical character.",
                        preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Try Again", style: .Cancel , handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    guessTextField.text = nil
                    return
                }
                if !hangmanGame!.phrase.uppercaseString.containsString(letter.uppercaseString) {
                    updateIncorrectGuesses(letter.uppercaseString)
                } else {
                    updateBlanks(letter.uppercaseString)
                }
            }
        } else {
            presentGameOverAlert()
        }
        guessTextField.text = nil
        
    }
    
    func updateIncorrectGuesses(letter: String) {
        if !hangmanGame!.incorrectGuesses.contains(letter) {
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
        
        hangmanGame!.incorrectGuesses.insert(letter)
        var incorrect = ""
        for letter in hangmanGame!.incorrectGuesses {
            incorrect += letter + " "
        }
        incorrectGuessesLabel.text = incorrect
        
    }
    
    func updateHangman() {
        hangmanGame!.hangmanImageState += 1
        if hangmanGame!.hangmanImageState == 7 {
            hangmanGame!.gameOver = 1
            presentGameOverAlert()
        }
        let imageFileName = "hangman" + String(hangmanGame!.hangmanImageState) + ".png"
        hangmanStateImageView.image = UIImage(named: imageFileName)
    }
    
    func updateBlanks(letter: String) {
        hangmanGame!.correctGuesses.insert(letter)
        
        var blanks = ""
        for character in hangmanGame!.phrase.characters {
            var blank = true
            for guess in hangmanGame!.correctGuesses {
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
        
        checkForWin()
        
    }
    
    func checkForWin() {
        var winCheck = 0
        for character in hangmanGame!.phrase.characters {
            if character != " " && !hangmanGame!.correctGuesses.contains(String(character)) {
                winCheck += 1
            }
        }
        if winCheck == 0 {
            hangmanGame!.winState = 1
            hangmanGame!.gameOver = 1
            presentGameOverAlert()
        }
    }
    
    func presentGameOverAlert()  {
        let alertController: UIAlertController
        if hangmanGame!.winState == 1 {
            alertController = UIAlertController(
                title: "Congratulations, You've won!",
                message: "You cannot input additional guesses.",
                preferredStyle: .Alert)
        } else {
            alertController = UIAlertController(
                title: "Sorry! You lost the game.",
                message: "You cannot input additional guesses.",
                preferredStyle: .Alert)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel , handler: nil)
        let newGameAction = UIAlertAction(title: "New Game", style: .Default) {
            (action) -> Void in
            self.newGame()
        }
        let startOverAction = UIAlertAction(title: "Start Over", style: .Default) {
            (action) -> Void in
            self.startOver()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(newGameAction)
        alertController.addAction(startOverAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func loadTargets() {
        guessButton.addTarget(self, action: "inputGuess", forControlEvents: .TouchUpInside)
        startOverButton.target = self
        startOverButton.action = "startOver"
        newGameButton.action = "newGame"
        newGameButton.target = self
        
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
