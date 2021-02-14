import Igis
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

public class ShellDirector : Director {
    private static var worldPlannableType: WorldPlannable.Type? = nil
    private static var karelExecutorType: KarelExecutor.Type? = nil

    public static func createWorld(worldPlannableType: WorldPlannable.Type,
                            karelExecutorType: KarelExecutor.Type) {
        Self.worldPlannableType = worldPlannableType
        Self.karelExecutorType = karelExecutorType
    }
    
    required init() {
        super.init()
        
        guard let worldPlannableType = Self.worldPlannableType else {
            fatalError("worldPlannableType must be establishished prior to initialization")
        }
        let worldPlannable = worldPlannableType.init()
        
        guard let karelExecutorType = Self.karelExecutorType else {
            fatalError("karelExecutorType must be established prior to initialization")
        }
        let karelExecutor = karelExecutorType.init()
          
        enqueueScene(scene:MainScene(worldPlannable: worldPlannable, karelExecutor: karelExecutor))
    }
}

