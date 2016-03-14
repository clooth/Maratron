//
//  main.swift
//  RockPaperScissors
//
//  Created by Nico Hämäläinen on 15/03/16.
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

/// Possible choices of stance in the game
enum Choice: Int {
  case Rock
  case Paper
  case Scissors
  case Invalid
}

extension Choice {
  /// Returns whether choice beats another choice
  ///
  /// - parameter choice: The choice to test against
  ///
  /// - returns: True if self beats `choice`
  func beats(choice: Choice) -> Bool {
    switch self {
    case .Rock:     return choice == .Scissors
    case .Paper:    return choice == .Rock
    case .Scissors: return choice == .Paper
    case .Invalid:  return false
    }
  }
  
  /// Returns the correct `Choice` value from `String` input
  ///
  /// - parameter string: The string value to check for choice
  ///
  /// - returns: The parsed Choice value
  static func fromString(string: String) -> Choice {
    switch string.uppercaseString {
    case "R": return .Rock
    case "P": return .Paper
    case "S": return .Scissors
    default:  return .Invalid
    }
  }
  
  /// Returns a random Choice
  /// - returns: A random `Choice` value
  static func randomChoice() -> Choice {
    // Pick a random choice
    return Choice(rawValue: random(0..<Choice.Invalid.rawValue))!
  }
  
  /// String representation of Choice values
  var description: String {
    switch self {
    case .Rock:     return "Rock"
    case .Paper:    return "Paper"
    case .Scissors: return "Scissors"
    case .Invalid:  return "Invalid"
    }
  }
}

/// Read the standard input into a `Choice` value
///
/// - parameter prompt: The prompt to print before input
///
/// - returns: The Choice input or nil
func getChoiceInput(prompt: String?) -> Choice {
  // Get string input from user
  guard let input = getStringInput(prompt) else {
    return .Invalid
  }
  
  return Choice.fromString(input)
}

func start() {
  print("Welcome to Rock Paper Scissors!")
  
  // Current round count
  var game = 0
  // Current player wins
  var wins = 0

  // Each game is a best of three
  while (game < 3) {
    // Get player choices
    let opposing = Choice.randomChoice()
    let friendly = getChoiceInput("(R)ock, (P)aper or (S)cissors?")
    
    // Check for tie
    if (opposing == friendly) {
      print("It's a draw!")
      continue
    }
    
    if (friendly.beats(opposing)) {
      print("\(friendly) beats \(opposing). You win!")
      wins += 1
    }
    else {
      print("\(opposing) beats \(friendly). You lose!")
    }
    
    // Move to next round
    game += 1
  }
  
  // Figure out final winner
  if (wins >= 2) {
    print("Congratulations. You won \(wins)-\(game-wins)!")
  }
  else {
    print("Sorry. You lost \(wins)-\(game-wins)...")
  }
  
  // Rematch?
  if getStringInput("Play again? Y/N")?.uppercaseString == "Y" {
    start()
  }
  else {
    print("Thanks for playing!")
  }
}

start()