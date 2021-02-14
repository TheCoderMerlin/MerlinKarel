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

import Igis

class World {
    
    let streetCount: Int
    let avenueCount: Int
    let beeperGridLocations: [GridLocation]

    let pixelsBetweenStreets: Int
    let pixelsBetweenAvenues: Int
    
    
    init(streetCount: Int, avenueCount: Int, beeperGridLocations: [GridLocation],
         pixelsBetweenStreets: Int, pixelsBetweenAvenues: Int) {
        self.streetCount = streetCount
        self.avenueCount = avenueCount
        self.beeperGridLocations = beeperGridLocations

        self.pixelsBetweenStreets = pixelsBetweenStreets
        self.pixelsBetweenAvenues = pixelsBetweenAvenues
    }

    convenience init(canvasSize: Size,
                     worldPlanner: WorldPlannable) {
        let pixelsBetweenStreets = (canvasSize.height - (Style.worldTopMargin + Style.worldBottomMargin)) / (worldPlanner.streetCount() - 1)
        let pixelsBetweenAvenues = (canvasSize.width - (Style.worldLeftMargin + Style.worldRightMargin)) / (worldPlanner.avenueCount()  - 1)

        self.init(streetCount: worldPlanner.streetCount(), avenueCount: worldPlanner.avenueCount(), beeperGridLocations: worldPlanner.beeperGridLocations(),
                  pixelsBetweenStreets: pixelsBetweenStreets, pixelsBetweenAvenues: pixelsBetweenAvenues)
    }

    func pointOnGrid(at gridLocation: GridLocation) -> Point {
        let x = Style.worldLeftMargin + pixelsBetweenAvenues * gridLocation.avenue
        let y = Style.worldTopMargin  + pixelsBetweenStreets * (streetCount - gridLocation.street - 1)

        return Point(x: x, y: y)
    }

}
