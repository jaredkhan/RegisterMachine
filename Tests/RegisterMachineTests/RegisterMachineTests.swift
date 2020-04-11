import XCTest
import RegisterMachine

class RegisterMachineTests: XCTestCase {
  func testCanIncrementRegisterWithoutStartValue() {
    let resultingRegisters = RegisterMachine.run(
      program:[
        .increment(register: 5, thenGoTo: 1),
        .increment(register: 5, thenGoTo: 2),
        .increment(register: 5, thenGoTo: 3),
        .halt
      ],
      startRegisters: [2: 3, 4: 5]
    )
    
    XCTAssertEqual(resultingRegisters[5], 3)
  }
  
  func testCanDoubleRegisterZero() {
    let doubleReg0: RegisterMachine.Program = [
      // Double register 0 into register 1
      .decrement(register: 0, success: 1, failure: 3),
      .increment(register: 1, thenGoTo: 2),
      .increment(register: 1, thenGoTo: 0),
      
      // Empty register 1 back into register 0
      .decrement(register: 1, success: 4, failure: 5),
      .increment(register: 0, thenGoTo: 3),
      .halt
    ]
    
    let resultingRegisters = RegisterMachine.run(
      program: doubleReg0,
      startRegisters: [0: 4]
    )
    
    XCTAssertEqual(resultingRegisters[0], 8)
  }
  
  func testCanPerformAddition() {
    let addReg1ToReg0: RegisterMachine.Program = [
      .decrement(register: 1, success: 1, failure: 2),
      .increment(register: 0, thenGoTo: 0),
      .halt
    ]
    
    XCTAssertEqual(
      RegisterMachine.run(
        program: addReg1ToReg0,
        startRegisters: [0: 4, 1: 3]
      )[0],
      7
    )
    
    XCTAssertEqual(
      RegisterMachine.run(
        program: addReg1ToReg0,
        startRegisters: [0: 4, 1: 0]
      )[0],
      4
    )
  }
  
  func testCanPerformSubtraction() {
    let subtractReg1FromReg0: RegisterMachine.Program = [
      .decrement(register: 1, success: 1, failure: 2),
      .decrement(register: 0, success: 0, failure: 0),
      .halt
    ]
    
    XCTAssertEqual(
      RegisterMachine.run(
        program: subtractReg1FromReg0,
        startRegisters: [0: 4, 1: 3]
      )[0],
      1
    )
    
    XCTAssertEqual(
      RegisterMachine.run(
        program: subtractReg1FromReg0,
        startRegisters: [0: 4, 1: 0]
      )[0],
      4
    )
    
    // The result cannot go lower than zero
    XCTAssertEqual(
      RegisterMachine.run(
        program: subtractReg1FromReg0,
        startRegisters: [0: 4, 1: 5]
      )[0],
      0
    )
  }
  
  func testCanPerformIntegerDivision() {
    let divideReg0ByReg1: RegisterMachine.Program = [
      // register 0: input numerator
      // register 1: input divisor
      // register 2: output quotient
      // register 3: workspace for restoring the divisor
      // non-terminating when input divisor is 0
      
      // subtract register 1 from register 0
      .decrement(register: 1, success: 1, failure: 3), // 0
      .increment(register: 3, thenGoTo: 2), // 1
      .decrement(register: 0, success: 0, failure: 6), // 2
      
      // Register 1 got down to zero.
      // Increment the quotient,
      .increment(register: 2, thenGoTo: 4), // 3
      
      // restore register 1 from register 3 then go back to the beginning
      .decrement(register: 3, success: 5, failure: 0), // 4
      .increment(register: 1, thenGoTo: 4), // 5

      .halt // 6
    ]

    XCTAssertEqual(
      RegisterMachine.run(
        program: divideReg0ByReg1,
        startRegisters: [0: 24, 1: 8]
      )[2],
      3
    )
    
    XCTAssertEqual(
      RegisterMachine.run(
        program: divideReg0ByReg1,
        startRegisters: [0: 4, 1: 3]
      )[2],
      0
    )
  }
}
