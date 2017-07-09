//
//  RegisterMachine.swift
//  RegisterMachine
//
//  Created by Jared Khan on 09/07/2017.
//  Copyright © 2017 Jared Khan. All rights reserved.
//

import Foundation

public typealias Register = Int
public typealias Line = Int

public class RegisterMachine {
  var registers = [Int: Int]()
  var program: [Instruction]
  var running = false
  var nextInstructionIndex = 0
  
  public init(program: [Instruction]) {
    self.program = program
  }
  
  public func run(with initialRegisterValues: [Int: Int] = [:]) {
    print("======== RUNNING ========")
    registers = initialRegisterValues
    print(registers)
    running = true
    while(running) {
      perform(instruction: program[nextInstructionIndex])
      print(registers)
    }
    print("========= HALT =========")
  }
  
  public static func encode(pair: (Int, Int)) -> Int {
    let (x,y) = pair
    return (2 * y + 1) << x
  }
  
  public static func decode(pair code: Int) -> (Int, Int) {
    var code = code
    var x = 0
    
    while (code % 2 == 0) {
      code = code / 2
      x = x + 1
    }
    
    code = code / 2
    let y = code
    
    return (x, y)
  }
  
  public static func encode(list: [Int]) -> Int {
    if let head = list.first {
      let tailEncoding = encode(list: Array(list.dropFirst(1)))
      return encode(pair: (head, tailEncoding))
    } else {
      return 0
    }
  }
  
  public static func decode(list code: Int) -> [Int] {
    if code == 0 {
      return []
    } else {
      let (head, tailCode) = decode(pair: code)
      return [head] + decode(list: tailCode)
    }
  }
  
  public func perform(instruction: Instruction) {
    switch instruction {
    case .increment(register: let register, goto: let nextLine):
      registers[register] = (registers[register] ?? 0) + 1
      nextInstructionIndex = nextLine
    case .decrement(register: let register, success: let successLine, failure: let failureLine):
      let currentValue = (registers[register] ?? 0)
      if (currentValue > 0) {
        registers[register] = currentValue - 1
        nextInstructionIndex = successLine
      } else {
        nextInstructionIndex = failureLine
      }
    case .halt:
      running = false
    }
  }
}

