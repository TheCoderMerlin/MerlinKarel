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
// If an error occurs 'isTerminated' will be set to true
// and further commands will be ignored

open class KarelExecutor {
    typealias ExecutionCompletedHandlerType = (_ wasTerminated: Bool) -> ()
    
    private weak var karel: Karel?
    private var executionCompletedHandler: ExecutionCompletedHandlerType? = nil
    private let semaphore = DispatchSemaphore(value: 0)
    private var isTerminated = false
    private var isSilentRunning = false // iff true, suppress successful printing
    
    public required init() {
    }

    internal func karelDidFinishNotification() {
        semaphore.signal()
    }

    internal func setKarel(karel: Karel) {
        self.karel = karel
        karel.setDidFinishNotification(karelDidFinishNotification)
    }

    internal func setExecutionCompletedHandler(executionCompletedHandler: @escaping ExecutionCompletedHandlerType) {
        self.executionCompletedHandler = executionCompletedHandler
    }

    // Begins the execution process of run on a separate thread
    internal func execute(isSilentRunning: Bool) {
        // Run silently if so specified
        self.isSilentRunning = isSilentRunning
        
        DispatchQueue(label: "KarelExecutor").asyncAfter(deadline: .now() + .milliseconds(1_000)) {
            // Run instructions
            self.printKarel(isSuccessful: true, "Started")
            
            self.run()

            if self.isTerminated {
                self.printKarel(isSuccessful: false, "HALTED ON ERROR")
            } else {
                self.printKarel(isSuccessful: true, "Finished")
            }

            if let executionCompletedHandler = self.executionCompletedHandler {
                executionCompletedHandler(self.isTerminated)
            }
        }
    }

    private func printKarel(isSuccessful: Bool, _ message:String) {
        if !isSuccessful || !isSilentRunning {
            if isSuccessful {
                print(Terminal.setColor(.green, .fore), terminator:"")
            } else {
                print(Terminal.setColor(.red, .fore), terminator:"")
            }

            print(Terminal.reverse(), "Karel:", Terminal.reset(), terminator:" ")
            print(message)
        }
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
        guard !isTerminated else {
            return
        }
        guard let karel = karel else {
            fatalError("karel is required for move()")
        }
        guard let world = karel.world else {
            fatalError("world is required for move()")
        }
        guard world.mayMoveForward(from: karel.currentGridLocation, heading: karel.currentDirection) else {
            printKarel(isSuccessful: false, "Karel may not move forward from here")
            isTerminated = true
            return
        }
        
        printKarel(isSuccessful: true, "move()")
        karel.animateForward()
        semaphore.wait()
    }

    // Turn karel counterclockwise ninety degrees
    public func turnLeft() {
        guard !isTerminated else {
            return
        }
        guard let karel = karel else {
            fatalError("karel is required for turnLeft()")
        }
        printKarel(isSuccessful: true, "turnLeft()")
        
        karel.animateTurnLeft()
        semaphore.wait()
    }

    // Place a beeper at the current corner (multiple beepers may be placed)
    public func putDownBeeper() {
        guard !isTerminated else {
            return
        }
        guard let karel = karel else {
            fatalError("karel is required for putDownBeeper()")
        }
        guard karel.beeperCount > 0 else {
            printKarel(isSuccessful: false, "Karel doesn't have any beepers to put down")
            isTerminated = true
            return
        }
        printKarel(isSuccessful: true, "putDownBeeper()")

        karel.removeBeeper()
        karel.interactionLayer().add(beeperAt: karel.currentGridLocation)
    }


    // Picks up a beeper from the current corner
    // Error if there are no beepers on the corner
    public func pickUpBeeper() {
        guard !isTerminated else {
            return
        }
        guard let karel = karel else {
            fatalError("karel is required for putDownBeeper()")
        }

        let gridLocation = karel.currentGridLocation
        guard karel.interactionLayer().beeperCount(at: gridLocation) > 0 else {
            printKarel(isSuccessful: false, "There are no beepers to pick up")
            isTerminated = true
            return
        }
        printKarel(isSuccessful: true, "pickUpBeeper()")

        karel.interactionLayer().remove(beeperAt: gridLocation)
        karel.addBeeper()
    }

    // Returns true iff karel may proceed foward
    public func isFrontClear() -> Bool {
        guard !isTerminated else {
            return false
        }
        printKarel(isSuccessful: true, "isFrontClear()")
        guard let karel = karel else {
            fatalError("karel is required for isFrontClear()")
        }
        guard let world = karel.world else {
            fatalError("world is required for isFrontClear()")
        }
        return world.mayMoveForward(from: karel.currentGridLocation, heading: karel.currentDirection) 
    }

    public func isLeftClear() -> Bool {
        guard !isTerminated else {
            return false
        }
        printKarel(isSuccessful: true, "isLeftClear()")
        guard let karel = karel else {
            fatalError("karel is required for isLeftClear()")
        }
        guard let world = karel.world else {
            fatalError("world is required for isLeftClear()")
        }
        return world.mayMoveForward(from: karel.currentGridLocation, heading: karel.currentDirection.toLeft()) 
    }
    
    public func isRightClear() -> Bool {
        guard !isTerminated else {
            return false
        }
        printKarel(isSuccessful: true, "isRightClear()")
        guard let karel = karel else {
            fatalError("karel is required for isRightClear()")
        }
        guard let world = karel.world else {
            fatalError("world is required for isRightClear()")
        }
        return world.mayMoveForward(from: karel.currentGridLocation, heading: karel.currentDirection.toRight()) 
    }
    

    // Returns true iff there is a beeper on the corner where karel is located
    public func isBeeperHere() -> Bool {
        guard !isTerminated else {
            return false
        }
        guard let karel = karel else {
            fatalError("karel is required for isBeeperHere()")
        }
        printKarel(isSuccessful: true, "isBeeperHere()")
        
        let gridLocation = karel.currentGridLocation
        return karel.interactionLayer().beeperCount(at: gridLocation) > 0
    }

    // Returns true iff karel is facing north
    public func isFacingNorth() -> Bool {
        guard !isTerminated else {
            return false
        }
        guard let karel = karel else {
            fatalError("karel is required for isFacingNorth()")
        }
        printKarel(isSuccessful: true, "isFacingNorth()")
        
        return karel.isFacing(direction: .north)
    }

    // Returns true iff karel is facing east
    public func isFacingEast() -> Bool {
        guard !isTerminated else {
            return false
        }
        guard let karel = karel else {
            fatalError("karel is required for isFacingEast()")
        }
        printKarel(isSuccessful: true, "isFacingEast()")
        
        return karel.isFacing(direction: .east)
    }

    // Returns true iff karel is facing south
    public func isFacingSouth() -> Bool {
        guard !isTerminated else {
            return false
        }
        guard let karel = karel else {
            fatalError("karel is required for isFacingSouth()")
        }
        printKarel(isSuccessful: true, "isFacingSouth()")
        
        return karel.isFacing(direction: .south)
    }

    // Returns true iff karel is facing west
    public func isFacingWest() -> Bool {
        guard !isTerminated else {
            return false
        }
        guard let karel = karel else {
            fatalError("karel is required for isFacingWest()")
        }
        printKarel(isSuccessful: true, "isFacingWest()")
        
        return karel.isFacing(direction: .west)
    }


}
