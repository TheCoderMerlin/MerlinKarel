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

public class MainScene : Scene {

    let backgroundLayer = BackgroundLayer()
    let interactionLayer = InteractionLayer()
    let foregroundLayer = ForegroundLayer()

    let worldPlanner: WorldPlannable
    let karelExecutor: KarelExecutor

    var world: World? = nil

    public init(worldPlanner: WorldPlannable, karelExecutor: KarelExecutor) {
        self.worldPlanner = worldPlanner
        self.karelExecutor = karelExecutor
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Main")

        // We insert our Layers in the constructor
        // We place each layer in front of the previous layer
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.inFrontOf(object:backgroundLayer))
        insert(layer:foregroundLayer, at:.front)

        // Set up karel for later execution
        karelExecutor.setKarel(karel: interactionLayer.karel)
        karelExecutor.execute()
    }

    public override func preSetup(canvasSize: Size, canvas: Canvas) {
        world = World(canvasSize: canvasSize, worldPlanner: worldPlanner)
    }
    
}
