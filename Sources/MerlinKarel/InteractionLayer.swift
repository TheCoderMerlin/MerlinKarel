import Scenes

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

class InteractionLayer : Layer {

    let karel = Karel()

    private var gridBeepers = [GridLocation: Beeper]()
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")

        // We insert our RenderableEntities in the constructor
        insert(entity: karel, at: .front)
    }

    func add(beeperAt gridLocation: GridLocation, count: Int = 1) {
        if gridBeepers[gridLocation] != nil {
            gridBeepers[gridLocation]!.increment(count: count)
        } else {
            let beeper = Beeper(gridLocation: gridLocation, initialCount: count)
            gridBeepers[gridLocation] = beeper 
            insert(entity: beeper, at: .back)
        }
    }

    func remove(beeperAt gridLocation: GridLocation) {
        precondition(gridBeepers[gridLocation] != nil, "The specified location \(gridLocation) does not contain any beepers.")
        precondition(gridBeepers[gridLocation]!.count() > 0, "The specified location \(gridLocation) does not contain enough beepers.")

        let beeper = gridBeepers[gridLocation]!
        beeper.decrement()
        if beeper.count() == 0 {
            self.remove(entity: beeper)
            gridBeepers.removeValue(forKey: gridLocation)
        }
    }

    func beeperCount(at gridLocation: GridLocation) -> Int {
        if let beeper = gridBeepers[gridLocation] {
            return beeper.count()
        } else {
            return 0
        }
    }
}
