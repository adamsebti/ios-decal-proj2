//
//  Hangman.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import Foundation

class Hangman {
    var words: HangmanWords!
    var answer: String?
    var knownString: String?
    var guessedLetters: NSMutableArray?
    var newGuess: Bool = false
    
    init() {
        words = HangmanWords()
    }
    
    func start() {
        let word = words.getRandomWord()
        answer = word
        knownString = ""
        for (var i = 0; i < answer!.characters.count; i += 1) {
            if (word as NSString).substringWithRange(NSMakeRange(i, 1)) == " " {
                knownString = knownString! + " "
            } else {
                knownString = knownString! + "_"
            }
        }
        guessedLetters = NSMutableArray()
    }
    
    func guessLetter(letter: String) -> Bool {
        var result = false
        if guessedLetters!.containsObject(letter) {
            return true
        }
        guessedLetters!.addObject(letter)
        var chars = Array(answer!.characters)
        
        for (var i = 0; i < answer!.characters.count; i += 1) {

            if String(chars[i]) == letter {
                result = true
                newGuess = true
                knownString = "\((knownString! as NSString).substringToIndex(i))" + "\(letter)"
                            + "\((knownString! as NSString).substringFromIndex(i+1))"
            }
            
        }
        print(knownString)
        return result
    }
    
    func guesses() -> String {
        if guessedLetters!.count == 0 {
            return ""
        }
        var result: String!
        for (var i = 0; i < guessedLetters!.count; i += 1) {
            result = result + ", \(guessedLetters?.objectAtIndex(i))"
        }
        return result
    }

}