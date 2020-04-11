# Swift Register Machine Implementation

This is a Swift implementation of a [register machine](https://en.wikipedia.org/wiki/Register_machine).

A register machine is a simple, turing-complete computation model. There are many flavours of register machine. The one modelled here has the following very small instruction set:

- `increment(register: RegisterAddress, thenGoTo: Line)`
  - Increments the value at the given register address then goes to the specified line of the program.
- `decrement(register: RegisterAddress, success: Line, failure: Line)`
  - Decrements the value at the given register address if it is greater than 0 then goes to the given `success` line of the or goes to the given `failure` line if the value was already 0.
- `halt`
  - Terminates the execution of the program.

The tests provide some brief examples of how to construct programs from these intructions.

Try it by cloning the repository and running:
```
swift test
```
