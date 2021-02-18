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

import Foundation
import Igis

class World {
    
    let avenueCount: Int
    let streetCount: Int
    let wallLocations: WallLocations

    let pixelsBetweenStreets: Int
    let pixelsBetweenAvenues: Int

    let initialSituation: Situation
    let goalSituation: Situation

    init(avenueCount: Int, streetCount: Int, wallLocations: WallLocations,
         pixelsBetweenStreets: Int, pixelsBetweenAvenues: Int,
         initialSituation: Situation, goalSituation: Situation) {
        self.avenueCount = avenueCount
        self.streetCount = streetCount
        self.wallLocations = wallLocations

        self.pixelsBetweenStreets = pixelsBetweenStreets
        self.pixelsBetweenAvenues = pixelsBetweenAvenues

        self.initialSituation = initialSituation
        self.goalSituation = goalSituation
    }

    convenience init(canvasSize: Size,
                     worldPlan: WorldPlan) {
        let pixelsBetweenStreets = (canvasSize.height - (Style.worldTopMargin + Style.worldBottomMargin)) / (worldPlan.streetCount() - 1)
        let pixelsBetweenAvenues = (canvasSize.width - (Style.worldLeftMargin + Style.worldRightMargin)) / (worldPlan.avenueCount()  - 1)

        self.init(avenueCount: worldPlan.avenueCount(), streetCount: worldPlan.streetCount(), wallLocations: worldPlan.wallLocations(),
                  pixelsBetweenStreets: pixelsBetweenStreets, pixelsBetweenAvenues: pixelsBetweenAvenues,
                  initialSituation: worldPlan.initialSituation(), goalSituation: worldPlan.goalSituation())
    }

    func pointOnGrid(at gridLocation: GridLocation) -> Point {
        let x = Style.worldLeftMargin + pixelsBetweenAvenues * gridLocation.avenue
        let y = Style.worldTopMargin  + pixelsBetweenStreets * (streetCount - gridLocation.street - 1)

        return Point(x: x, y: y)
    }

    var firstStreet: Int {
        return 1
    }

    var lastStreet: Int {
        return streetCount - 2
    }

    var firstAvenue: Int {
        return 1
    }

    var lastAvenue: Int {
        return avenueCount - 2
    }

    public func mayMoveForward(from gridLocation: GridLocation, heading: CompassDirection) -> Bool {
        switch (gridLocation.avenue, gridLocation.street, heading) {
        case (firstAvenue, _, .west):
            return false
        case (lastAvenue, _, .east):
            return false
        case (_, firstStreet, .south):
            return false
        case (_, lastStreet, .north):
            return false
        case (let avenue, let street, .north):
            return !wallLocations.isWall(at: WallLocation(gridLocation: GridLocation(avenue: avenue, street: street), side: .above))
        case (let avenue, let street, .east):
            return !wallLocations.isWall(at: WallLocation(gridLocation: GridLocation(avenue: avenue, street: street), side: .right))
        case (let avenue, let street, .south):
            return !wallLocations.isWall(at: WallLocation(gridLocation: GridLocation(avenue: avenue, street: street - 1), side: .above))
        case (let avenue, let street, .west):
            return !wallLocations.isWall(at: WallLocation(gridLocation: GridLocation(avenue: avenue - 1, street: street), side: .right))
        }
    }
    
    func isMerlinMissionManagerMode() -> Bool {
        return ProcessInfo.processInfo.environment["merlinMissionManagerMode"] == "IGIS"
    }

    func merlinMissionManagerKey() -> String? {
        return ProcessInfo.processInfo.environment["merlinMissionManagerKey"]
    }
}
