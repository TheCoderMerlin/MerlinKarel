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

open class WorldPlan {
    public required init() {
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // UTILITY FUNCTIONS
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public func addHorizontalWallSegment(wallLocations: inout WallLocations, from: GridLocation, through: GridLocation) {
        precondition(from.street == through.street, "Streets must be the same for horizontal segments")
        let increment = (through.avenue - from.avenue).signum()
        if increment == 0 {
            wallLocations.addWall(at: WallLocation(gridLocation: from, side: .above))
        } else
        {
            for avenue in stride(from: from.avenue, through: through.avenue, by: increment) {
                let gridLocation = GridLocation(avenue: avenue, street: from.street)
                wallLocations.addWall(at: WallLocation(gridLocation: gridLocation, side: .above))
            }
        }
    }

    public func addVerticalWallSegment(wallLocations: inout WallLocations, from: GridLocation, through: GridLocation) {
        precondition(from.avenue == through.avenue, "Avenues must be the same for vertical segments")
        let increment = (through.street - from.street).signum()
        if increment == 0 {
            wallLocations.addWall(at: WallLocation(gridLocation: from, side: .right))
        } else {
            for street in stride(from: from.street, through: through.street, by: increment) {
                let gridLocation = GridLocation(avenue: from.avenue, street: street)
                wallLocations.addWall(at: WallLocation(gridLocation: gridLocation, side: .right))
            }
        }
    }

    public func addWallSegment(wallLocations: inout WallLocations, from: GridLocation, through: GridLocation) {
        switch (from, through) {
        case (let from, let through) where from.street == through.street:
            addHorizontalWallSegment(wallLocations: &wallLocations, from: from, through: through)
        case (let from, let through) where from.avenue == through.avenue:
            addVerticalWallSegment(wallLocations: &wallLocations, from: from, through: through)
        default:
            fatalError("Unable to create a wall segment across diagonals")
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // API FOLLOWS
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func avenueCount() -> Int {
        return 10
    }
    
    open func streetCount() -> Int {
        return 10
    }
    
    open func wallLocations() -> WallLocations {
        let wallLocations = WallLocations()
        return wallLocations
    }

    open func initialSituation() -> Situation {
        let gridLocationBeeperCounts : Situation.GridLocationBeeperCounts  = [
          GridLocation(avenue: 3, street: 2) : 1
        ]

        let situation = Situation(
          karelGridLocation: GridLocation(avenue: 1, street: 3),
          karelCompassDirection: .north,
          karelBeeperCount: 0,
          gridLocationBeeperCounts: gridLocationBeeperCounts
        )
        return situation
    }
    
    open func goalSituation() -> Situation {
        return initialSituation()
    }
}
