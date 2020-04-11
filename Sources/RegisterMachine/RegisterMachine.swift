//
//  RegisterMachine.swift
//  RegisterMachine
//
//  Created by Jared Khan on 09/07/2017.
//  Copyright © 2017 Jared Khan. All rights reserved.
//

import Foundation

public struct RegisterMachine {
  public typealias RegisterAddress = Int
  public typealias RegisterValue = UInt
  public typealias Registers = [RegisterAddress: RegisterValue]
  public typealias Line = Int

  /// A single step in a register machine program.
  public enum Instruction: Equatable {
    
    /// Increments the value at the given register address then goes to the specified line of the program.
    case increment(register: RegisterAddress, thenGoTo: Line)
    
    /// Decrements the value at the given register address if it is greater than 0
    /// then goes to the given `success` line of the program
    /// or goes to the given `failure` line if the value was already 0.
    case decrement(register: RegisterAddress, success: Line, failure: Line)
    
    /// Terminates the execution of the program.
    case halt
    
  }
  
  public typealias Program = [Instruction]
  let program: Program
  
  var registers: Registers
  var instruction: Instruction
  var running = false
  
  public init(program: Program, startRegisters: Registers) {
    self.program = program
    self.registers = startRegisters
    self.instruction = program[0]
  }
  
  mutating func increment(register: RegisterAddress, thenGoTo line: Line) {
    registers[register] = (registers[register] ?? 0) + 1
    instruction = program[line]
  }
  
  mutating func decrement(register: RegisterAddress, success: Line, failure: Line) {
    let currentValue = (registers[register] ?? 0)
    if (currentValue > 0) {
      registers[register] = currentValue - 1
      instruction = program[success]
    } else { instruction = program[failure] }
  }
  
  /// Runs the register machine.
  /// - Returns: Contents of the registers after program termination
  public mutating func run() -> Registers {
    while(true) {
      switch instruction {
      case let .increment(register: register, thenGoTo: line):
        increment(register: register, thenGoTo: line)
      case let .decrement(register: register, success: success, failure: failure):
        decrement(register: register, success: success, failure: failure)
      case .halt:
        return registers
      }
    }
  }
  
  /// Runs a register machine with the given program.
  /// - Parameters:
  ///   - program: Program to run
  ///   - startRegisters: The start values of the registers
  /// - Returns: Contents of the registers after program termination
  public static func run(program: Program, startRegisters: Registers) -> Registers {
    var machine = self.init(program: program, startRegisters: startRegisters)
    return machine.run()
  }
}
