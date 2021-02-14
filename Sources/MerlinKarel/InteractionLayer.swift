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

    func add(beeperAt gridLocation: GridLocation) {
        precondition(gridBeepers[gridLocation] == nil, "The specificed location \(gridLocation) already contains a beeper.")

        let beeper = Beeper(gridLocation: gridLocation)
        gridBeepers[gridLocation] = beeper
        insert(entity: beeper, at: .front)
    }

    func remove(beeperAt gridLocation: GridLocation) {
        precondition(gridBeepers[gridLocation] != nil, "The specified location \(gridLocation) does not contain a beeper.")
        
        gridBeepers.removeValue(forKey: gridLocation)
    }
}
