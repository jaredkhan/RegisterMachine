//
//  Instruction.swift
//  RegisterMachine
//
//  Created by Jared Khan on 09/07/2017.
//  Copyright © 2017 Jared Khan. All rights reserved.
//

import Foundation

public extension RegisterMachine {
  public enum Instruction: Equatable {
    case increment(register: Register, goto: Line)
    case decrement(register: Register, success: Line, failure: Line)
    case halt
    
    var encoding: Int {
      switch (self) {
      case .halt:
        return 0
      case .increment(register: let register, goto: let nextLine):
        // Always even
        return 2 * RegisterMachine.encode(pair: (register, nextLine))
      case .decrement(register: let register, success: let success, failure: let failure):
        // Always odd
        return 2 * RegisterMachine.encode(list: [register, success, failure]) + 1
      }
    }
    
    public static func ==(lhs: Instruction, rhs: Instruction) -> Bool {
      switch (lhs, rhs) {
      case (.halt, .halt):
        return true
      case (let .increment(register1, goto1), let .increment(register2, goto2)):
        return register1 == register2 && goto1 == goto2
      case (let .decrement(register1, success1, failure1), let .decrement(register2, success2, failure2)):
        return register1 == register2 && success1 == success2 && failure1 == failure2
      default:
        return false
      }
    }
    
    public init?(from encoding: Int) {
      if encoding == 0 {
        self = .halt
      } else if encoding % 2 == 0 {
        let (register, nextLine) = RegisterMachine.decode(pair: encoding / 2)
        self = .increment(register: register, goto: nextLine)
      } else {
        let values = RegisterMachine.decode(list: encoding / 2)
        if values.count != 3 {
          return nil
        } else {
          let register = values[0]
          let success = values[1]
          let failure = values[2]
          self = .decrement(register: register, success: success, failure: failure)
        }
      }
    }
  }
}

