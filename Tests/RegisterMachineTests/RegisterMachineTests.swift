import XCTest
@testable import RegisterMachine

class RegisterMachineTests: XCTestCase {
  func testEncodings() {
    // Pairs
    XCTAssertTrue(testEncoding(of: (0,0)))
    XCTAssertTrue(testEncoding(of: (1,2)))
    XCTAssertTrue(testEncoding(of: (3,4)))
    
    // Lists
    XCTAssertTrue(testEncoding(of: [0]))
    XCTAssertTrue(testEncoding(of: [1]))
    XCTAssertTrue(testEncoding(of: [1, 2]))
    XCTAssertTrue(testEncoding(of: [1, 2, 3]))
    
    // Instructions
    XCTAssertTrue(testEncoding(of: RegisterMachine.Instruction.halt))
    XCTAssertTrue(testEncoding(of: RegisterMachine.Instruction.decrement(
      register: 1,
      success: 2,
      failure: 3
    )))
    XCTAssertTrue(testEncoding(of: RegisterMachine.Instruction.increment(
      register: 1,
      goto: 0
    )))
  }
  
  func testEncoding(of pair: (Int, Int)) -> Bool {
    return RegisterMachine.decode(pair: RegisterMachine.encode(pair: pair)) == pair
  }
  
  func testEncoding(of list: [Int]) -> Bool {
    let encoding = RegisterMachine.encode(list: list)
    return RegisterMachine.decode(list: encoding) == list
  }
  
  func testEncoding(of instruction: RegisterMachine.Instruction) -> Bool {
    let encoding = instruction.encoding
    if let decoding = RegisterMachine.Instruction(from: encoding) {
      return instruction == decoding
    } else {
      return false
    }
  }
  
  static var allTests = [
    ("testEncodings", testEncodings),
  ]
}
