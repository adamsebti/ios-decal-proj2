//
//  HangmanWords.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import Foundation

class HangmanWords {
    var words : NSArray!

    init() {
        let path = NSBundle.mainBundle().pathForResource("words", ofType: "plist")
        words = NSArray.init(contentsOfFile: path!)
    }
    
    func getRandomWord() -> String! {
        let ind = Int(arc4random_uniform(UInt32(words.count)))
        return words.objectAtIndex(ind) as! String
    }

}