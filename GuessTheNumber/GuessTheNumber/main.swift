//
//  main.swift
//  GuessTheNumber
//
//  Created by Nico Hämäläinen on 14/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//
import Foundation

/// Returns a random Int within the `Range` given.
///
/// - parameter range: The `Range` to get the value between
///
/// - returns: The random `Int` picked
func random(range: Range<Int>) -> Int {
  let offset = range.startIndex < 0 ? abs(range.startIndex) : 0
  
  let minimum = UInt32(range.startIndex + offset)
  let maximum = UInt32(range.endIndex   + offset)
  
  return Int(minimum + arc4random_uniform(maximum - minimum)) - offset
}

/// Read the standard input into a `String` value
///
/// - parameter prompt: The prompt to print before input
///
/// - returns: The string input or nil
func getStringInput(prompt: String?) -> String? {
  if let prompt = prompt {
    print(prompt, terminator: " ")
  }
  
  // Read input
  let input = NSFileHandle.fileHandleWithStandardInput().availableData
  if let string = String(data: input, encoding: NSUTF8StringEncoding) {
    return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
  
  return nil
}

/// Read the standard input into an `Int` value
///
/// - parameter prompt: The prompt to print before input
///
/// - returns: The Int input or nil
func getIntInput(prompt: String?) -> Int? {
  if let inputString = getStringInput(prompt), input = Int(inputString) {
    return input
  }
  return nil
}

/// Starts the guessing game with given bounds
///
/// - parameter minimum: The minimum value the number can be
/// - parameter maximum: The maximum value the number can be
func start(minimum: Int = 1, maximum: Int = 100) {
  print("Guess the number! \(minimum)-\(maximum)")
  
  // Generate random number
  let correct = random(minimum...maximum)
  var guessed = -1
  
  // Loop the guessing part until user guesses it
  while (guessed != correct) {
    if let guess = getIntInput("Enter your guess:") {
      guessed = guess
      
      // Check the results
      if (guessed < correct) {
        print("Too low!")
      }
      else if (guessed > correct) {
        print("Too high!")
      }
      else {
        print("Correct!")
        
        // Play again?
        if getStringInput("Want to play again? Y/N")?.uppercaseString == "Y" {
          start(minimum, maximum: maximum)
        }
        else {
          print("Thanks for playing!")
        }

        break;
      }
    }
    else {
      print("Please enter a valid number between \(minimum) and \(maximum).")
    }
  }
}

// Start
start(1, maximum: 100)
