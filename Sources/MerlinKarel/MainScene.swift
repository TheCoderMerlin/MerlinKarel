import Foundation
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

    let worldPlannable: WorldPlannable
    let karelExecutor: KarelExecutor

    var world: World? = nil

    public init(worldPlannable: WorldPlannable, karelExecutor: KarelExecutor) {
        self.worldPlannable = worldPlannable
        self.karelExecutor = karelExecutor
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Main")

        // We insert our Layers in the constructor
        // We place each layer in front of the previous layer
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.inFrontOf(object:backgroundLayer))
        insert(layer:foregroundLayer, at:.front)

        // Set up karel
        karelExecutor.setKarel(karel: interactionLayer.karel)
        karelExecutor.setExecutionCompletedHandler(executionCompletedHandler: executionCompletedHandler)
    }

    public override func preSetup(canvasSize: Size, canvas: Canvas) {
        // Set up world
        world = World(canvasSize: canvasSize, worldPlannable: worldPlannable)

        // Set up beepers
        for (gridLocation, count) in world!.initialSituation.gridLocationBeeperCounts {
            interactionLayer.add(beeperAt: gridLocation, count: count)
        }

        // Set up karel
        interactionLayer.karel.setInitial(gridLocation: world!.initialSituation.karelGridLocation,
                                          compassDirection: world!.initialSituation.karelCompassDirection,
                                          beeperCount: world!.initialSituation.karelBeeperCount)
        
        // Begin execution
        karelExecutor.execute()
    }

    private func executionCompletedHandler(isSuccessful: Bool) {
        guard let world = world else {
            fatalError("world is required in executionCompeltedHandler")
        }

        // Exit at this point with error code, only if we are in merlinMissionmanagermode
        if world.isMerlinMissionManagerMode() {
            exit(isSuccessful ? 0 : 1)
        }
    }
    
}
