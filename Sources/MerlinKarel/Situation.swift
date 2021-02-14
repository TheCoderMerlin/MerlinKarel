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

public class Situation: CustomStringConvertible {
    public typealias GridLocationBeeperCounts = [GridLocation: Int]
    
    let karelGridLocation: GridLocation
    let karelCompassDirection: CompassDirection
    let karelBeeperCount: Int
    
    let gridLocationBeeperCounts: GridLocationBeeperCounts

    public init(karelGridLocation: GridLocation,
         karelCompassDirection: CompassDirection,
         karelBeeperCount: Int,
         gridLocationBeeperCounts: GridLocationBeeperCounts) {
        self.karelGridLocation = karelGridLocation
        self.karelCompassDirection = karelCompassDirection
        self.karelBeeperCount = karelBeeperCount
        
        self.gridLocationBeeperCounts = gridLocationBeeperCounts
    }

    public var description: String {
        var s = "karelGridLocation: \(karelGridLocation)\n"
        s += "karelCompassDirection: \(karelCompassDirection)\n"
        s += "karelBeeperCount: \(karelBeeperCount)\n"

        s += "beeperGridLocations:\n"

        let nonZeroKeys = gridLocationBeeperCounts.keys.filter { gridLocationBeeperCounts[$0]! > 0 }
        let sortedKeys = nonZeroKeys.sorted()
        for key in sortedKeys {
            s += "\t\(key): \(gridLocationBeeperCounts[key]!)\n"
        }

        return s
    }


}
