import Scenes
import ScenesAnimations
import Igis

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

class Beeper: KarelRenderableEntity {

    private let gridLocation: GridLocation
    private let ellipse = Ellipse(center: Point.zero, radiusX: 0, radiusY: 0, fillMode: .fillAndStroke)
    private let circle = Ellipse(center: Point.zero, radiusX: 0, radiusY: 0, fillMode: .fillAndStroke)
    private let beeperText = Text(location: Point.zero, text: "0")
    
    private var gradient: Gradient? = nil

    private var rotateRadians = 0.0

    private var countIndicator: Int 

    init(gridLocation: GridLocation, initialCount: Int) {
        self.gridLocation = gridLocation
        self.countIndicator = initialCount

        beeperText.font = Style.beeperFont
        beeperText.alignment = .center
        beeperText.baseline = .middle
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        guard let world = world else {
            fatalError("world required for setup")
        }

        let gridBars = max(world.avenueCount, world.streetCount)
        let size = min(canvasSize.width, canvasSize.height) / gridBars / 3
        ellipse.radiusX = size * 4  /  5
        ellipse.radiusY = size * 12 / 10

        circle.radiusX = size 
        circle.radiusY = size

        let location = world.pointOnGrid(at: gridLocation)
        ellipse.center = location
        circle.center = location
        beeperText.location = location

        gradient = Gradient(mode: .radial(center1: circle.center, radius1: 0,
                                          center2: circle.center, radius2: Double(circle.radiusX)))
        gradient!.addColorStop(ColorStop(position: 0.0, color: Style.beeperGradientCenterColor))
        gradient!.addColorStop(ColorStop(position: 1.0, color: Style.beeperGradientEdgeColor))
        canvas.setup(gradient!)

        let tweenRotation = Tween(from: 0.0, to: 2.0 * Double.pi, duration: Style.standardAnimationDurationSeconds, ease: .linear) {self.rotateRadians = $0}
        tweenRotation.repeatStyle = .forever
        animationController.register(animation: tweenRotation)
        tweenRotation.play()
        
    }

    override func calculate(canvasSize: Size) {
        // Set text
        beeperText.text = "\(countIndicator)"
        
        // Rotate as indicated
        let center = DoublePoint(ellipse.center)
        let preTranslate = Transform(translate: center)
        let rotate = Transform(rotateRadians: rotateRadians)
        let postTranslate = Transform(translate: -center)
        setTransforms(transforms:[preTranslate, rotate, postTranslate])
    }

    override func render(canvas: Canvas) {
        if let gradient = gradient,
           gradient.isReady {
            let fillStyle = FillStyle(gradient: gradient)
            canvas.render(fillStyle, Style.beeperStrokeStyle,
                          ellipse, circle)

            canvas.render(Style.beeperTextFillStyle, beeperText)
        }
    }

    func count() -> Int {
        return countIndicator
    }

    func increment(count: Int = 1) {
        countIndicator += count
    }

    func decrement() {
        precondition(countIndicator >= 1, "No beepers to remove")
        countIndicator -= 1
    }
    
}
