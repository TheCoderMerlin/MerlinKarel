import Glibc
import Dispatch

/*
MerlinKarel provides a Swift object library with support for Karel.
MerlinKarel is inspired by Richard E. Pattis in his book
"Karel The Robot: A Gentle Introduction to the Art of Programming".
MerlinKarel runs on top of Scenes, which in turn runs on top of IGIS.
Copyright (C) 2020-2021 Tango Golf Digital, LLC
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

// Executes an ActionPlan in a separate thread,
// enabling Igis to proceed normally
// Each statement in the plan completes in Igis
// before the next statement begins

open class KarelExecutor {

    private weak var karel: Karel?
    private let semaphore = DispatchSemaphore(value: 0)
    
    public init() {
    }

    internal func karelDidFinishNotification() {
        semaphore.signal()
    }

    internal func setKarel(karel: Karel) {
        self.karel = karel
        karel.setDidFinishNotification(karelDidFinishNotification)
    }

    // Begins the execution process of run on a separate thread
    internal func execute() {
        DispatchQueue(label: "KarelExecutor").asyncAfter(deadline: .now() + .milliseconds(1_000)) {
            self.run()
        }
    }

    private func printKarel(isSuccessful: Bool, _ message:String) {
        if isSuccessful {
            print(Terminal.setColor(.green, .fore), terminator:"")
        } else {
            print(Terminal.setColor(.red, .fore), terminator:"")
        }
        print(Terminal.reverse(), "Karel:", Terminal.reset(), terminator:" ")
        print(message)
    }
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // API FOLLOWS
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Executes in a separate thread to enable igis to proceed normally
    // Must be overridden in descendent classes
    open func run() {
        printKarel(isSuccessful: false, "Nothing to do")
    }

    // Move karel forward in the direction he is facing
    public func move() {
        printKarel(isSuccessful: true, "move()")
        guard let karel = karel else {
            fatalError("karel is required for move()")
        }
        karel.animateForward()
        semaphore.wait()
    }

    // Turn karel counterclockwise ninety degrees
    public func turnLeft() {
        printKarel(isSuccessful: true, "turnLeft()")
        guard let karel = karel else {
            fatalError("karel is required for turnLeft()")
        }
        karel.animateTurnLeft()
        semaphore.wait()
    }

    // // Turn karel clockwise ninety degrees
    // public func turnRight() {
    //     printKarel(isSuccessful: true, "turnRight()")
    //     guard let karel = karel else {
    //         fatalError("karel is required for turnRight()")
    //     }
    //     karel.animateTurnRight()
    //     semaphore.wait()
    // }

    // Place a beeper at the current corner (multiple beepers may be placed)
    public func putDownBeeper() {
    }


    // Picks up a beeper from the current corner
    // Error if there are no beepers on the corner
    public func pickUpBeeper() {
    }

    // Returns true iff karel may proceed foward
    public func isFrontClear() -> Bool {
        return false
    }

    // Returns true iff karel may proceed to the left
    public func isLeftClear() -> Bool {
        return false
    }

    // Returns true iff karel may proceed to the right
    public func isRightClear() -> Bool {
        return false
    }

    // Returns true iff there is a beeper on the corner where karel is located
    public func isBeeperHere() -> Bool {
        return false
    }

    // Returns true iff karel is facing north
    public func isFacingNorth() -> Bool {
        guard let karel = karel else {
            fatalError("karel is required for isFacingNorth()")
        }
        return karel.isFacing(direction: .north)
    }

    // Returns true iff karel is facing east
    public func isFacingEast() -> Bool {
        guard let karel = karel else {
            fatalError("karel is required for isFacingEast()")
        }
        return karel.isFacing(direction: .east)
    }

    // Returns true iff karel is facing south
    public func isFacingSouth() -> Bool {
        guard let karel = karel else {
            fatalError("karel is required for isFacingSouth()")
        }
        return karel.isFacing(direction: .south)
    }

    // Returns true iff karel is facing west
    public func isFacingWest() -> Bool {
        guard let karel = karel else {
            fatalError("karel is required for isFacingWest()")
        }
        return karel.isFacing(direction: .west)
    }

}
