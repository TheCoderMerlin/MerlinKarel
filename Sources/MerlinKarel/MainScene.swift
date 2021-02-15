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

public class MainScene : Scene, KeyDownHandler {

    private enum ShowMode {
        case running
        case goal

        func toggled() -> Self {
            switch self {
            case .running:
                return .goal
            case .goal:
                return .running
            }
        }
    }
    private var showMode: ShowMode = .running

    let backgroundLayer = BackgroundLayer(color: Style.initialBackgroundColor)
    let interactionLayer = InteractionLayer()
    let foregroundLayer = ForegroundLayer()

    let goalBackgroundLayer = BackgroundLayer(color: Style.goalBackgroundColor)
    let goalInteractionLayer = InteractionLayer()

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
        let initialSituation = world!.initialSituation
        let goalSituation = world!.goalSituation

        // Set up beepers in initial situation
        for (gridLocation, count) in initialSituation.gridLocationBeeperCounts {
            interactionLayer.add(beeperAt: gridLocation, count: count)
        }

        // Set up karel in initial situation
        interactionLayer.karel.setInitial(gridLocation: initialSituation.karelGridLocation,
                                          compassDirection: initialSituation.karelCompassDirection,
                                          beeperCount: initialSituation.karelBeeperCount)
        if world!.isMerlinMissionManagerMode() {
            interactionLayer.karel.setAnimationDurationSeconds(Style.merlinMissionManagerAnimationDurationSeconds)
        }

        // Set up beepers in goal situation
        for (gridLocation, count) in goalSituation.gridLocationBeeperCounts {
            goalInteractionLayer.add(beeperAt: gridLocation, count: count)
        }
        
        // Set up karel in goal situation
        goalInteractionLayer.karel.setInitial(gridLocation: goalSituation.karelGridLocation,
                                              compassDirection: goalSituation.karelCompassDirection,
                                              beeperCount: goalSituation.karelBeeperCount)

        

        // Set up key handling
        dispatcher.registerKeyDownHandler(handler: self)
        
        // Begin execution
        karelExecutor.execute(isSilentRunning: world!.isMerlinMissionManagerMode())
    }

    public override func postTeardown() {
        // Remove key handling
        dispatcher.unregisterKeyDownHandler(handler: self)
    }

    private func executionCompletedHandler(wasTerminated: Bool) {
        guard let world = world else {
            fatalError("world is required in executionCompeltedHandler")
        }

        // Exit at this point with error code, only if we are in merlinMissionmanagermode
        if world.isMerlinMissionManagerMode() {
            let goalMet = (!wasTerminated && world.goalSituation == interactionLayer.currentSituation())

            guard let key = world.merlinMissionManagerKey() else {
                fatalError("key required in merlinMissionManagerMode")
            }
            print("Success!")
            print(key)

            // Allow any running animations to complete
            sleep(UInt32(Style.standardAnimationDurationSeconds * 2.0))
            exit(goalMet ? 0 : 1)
        }
    }

    public func onKeyDown(key: String, code: String, ctrlKey: Bool, shiftKey: Bool, altKey: Bool, metaKey: Bool) {
        guard let world = world else {
            fatalError("world is required in onKeyDown")
        }

        // Ignore key presses in MerlinMissionManagerMode
        if !world.isMerlinMissionManagerMode() {
            if code == "Space" {
                if showMode == .running {
                    insert(layer: goalBackgroundLayer, at: .front)
                    insert(layer: goalInteractionLayer, at: .inFrontOf(object: goalBackgroundLayer))
                } else {
                    remove(layer: goalInteractionLayer)
                    remove(layer: goalBackgroundLayer)
                }
                showMode = showMode.toggled()
            }
        }
    }
    
    
}
