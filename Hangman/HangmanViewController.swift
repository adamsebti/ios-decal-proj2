//
//  ViewController.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startoverButton: UIButton!
    @IBOutlet weak var guesses: UILabel!
    @IBOutlet weak var newgameButton: UIButton!
    @IBOutlet weak var submitGuess: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var guessInput: UITextField!
    @IBOutlet weak var remainingLetters: UILabel!
    var game: Hangman!
    var stage: Int = 1
    var stop: Bool = false
    var correct: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        game = Hangman()
        newGame()
        newgameButton.addTarget(self, action: "newGame", forControlEvents: .TouchUpInside)
        submitGuess.addTarget(self, action: "submitGuessFunc", forControlEvents: .TouchUpInside)
        startoverButton.addTarget(self, action: "startOver", forControlEvents: .TouchUpInside)
        self.guessInput.delegate = self
        self.guessInput.clearsOnBeginEditing = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newGame(){
        game.start();
        self.remainingLetters.text = ""
        stage = 1
        self.stop = false
        var image: UIImage! = UIImage(named: "hangman1.gif")
        self.imageView.image = image
        guesses!.text = "Guesses: "
        correct = 0
        for letter in (game.answer?.characters)!{
            if(letter == " "){
                self.remainingLetters.text! += "    "
            } else {
                self.remainingLetters.text! += "_ "
            }
        }
        
    }
    
    func submitGuessFunc(){
        var guessinput: String? = self.guessInput.text!.capitalizedString
        self.guessInput.text = ""
        if(guessinput?.characters.count > 1){
            return
        }
        if(stop){
            return
        }
        var guess: Bool = game.guessLetter(guessinput!)
        if (guess){
            if(game.newGuess){
                replaceLabelText(guessinput!)
                game.newGuess = false
            }
        } else {
            wrongGuess(guessinput!)
        }
    }
    func wrongGuess(guess:String?){
        stage++
        if(stage == 7){
            stopGame()
        }
        var image: UIImage! = UIImage(named: "hangman" + String(stage) + ".gif")
        self.imageView.image = image
        if(guesses!.text!.characters.count > 9){
            guesses.text = guesses.text! + ", " + guess!
        } else {
            guesses.text = guesses.text! +  guess!
        }
    }
    
    func stopGame(){
        stop = true
        self.view.frame.origin.y -= 250
        let alertController = UIAlertController(title: "Defeat!", message:
            "You lose!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        guessInput.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 250
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 250
    }
    
    func replaceLabelText(letter: String?){
        var tempAnswer: String? = game.answer!
        var removed: Int = 0
        while((tempAnswer!.characters.indexOf(Character(letter!))) != nil) {
            var pos: Int = game.answer!.startIndex.distanceTo(tempAnswer!.characters.indexOf(Character(letter!))!) + removed
            var chars = Array(game.answer!.characters)
            var upper: Int = pos
            for (var i = 0; i < upper; i += 1) {
                if String(chars[i]) == " " {
                    pos += 1
                }
            }
            var labelText: String? = remainingLetters.text
            labelText!.insert(Character(letter!), atIndex: labelText!.startIndex.advancedBy(2*pos))
            labelText!.removeAtIndex(labelText!.startIndex.advancedBy(2*pos+1))
            remainingLetters.text = labelText
            tempAnswer?.removeAtIndex(tempAnswer!.characters.indexOf(Character(letter!))!)
            removed++
            correct++
        }
        var total: Int  = 0
        var characters = game.answer!.characters
        for letter in characters{
            if(String(letter) != " "){
                total += 1
            }
        }
        if(correct == total){
            gameWon()
        }
    }
    
    func startOver(){
        self.remainingLetters.text = ""
        stage = 1
        self.stop = false
        self.game.guessedLetters = NSMutableArray()
        var image: UIImage! = UIImage(named: "hangman1.gif")
        self.imageView.image = image
        guesses!.text = "Guesses: "
        correct = 0
        print(game.answer)
        for letter in (game.answer?.characters)!{
            if(letter == " "){
                self.remainingLetters.text! += "    "
            } else {
                self.remainingLetters.text! += "_ "
            }
        }

    }
    
    func gameWon(){
        stop = true
        self.view.frame.origin.y -= 250
        let alertController = UIAlertController(title: "Victory!", message:
            "You win!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
}

