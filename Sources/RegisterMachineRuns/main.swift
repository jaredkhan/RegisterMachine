//
//  main.swift
//  RegisterMachineRuns
//
//  Created by Jared Khan on 09/07/2017.
//

import Foundation
import RegisterMachine

let instructions: [RegisterMachine.Instruction] = [
  .increment(register: 0, goto: 1),
  .increment(register: 0, goto: 2),
  .halt
]

let machine = RegisterMachine(program: instructions)
machine.run()

let doubleInstructions: [RegisterMachine.Instruction] = [
  // Double 0 into 1
  .decrement(register: 0, success: 1, failure: 3),
  .increment(register: 1, goto: 2),
  .increment(register: 1, goto: 0),
  
  // Empty 1 back into 0
  .decrement(register: 1, success: 4, failure: 5),
  .increment(register: 0, goto: 3),
  .halt
]

let doubleMachine = RegisterMachine(program: doubleInstructions)
doubleMachine.run(with: [0: 4])
