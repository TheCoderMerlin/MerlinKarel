import Foundation
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

class Karel: KarelRenderableEntity {
    typealias DidFinishNotification = () -> ()
    
    private let url = URL(string: "https://www.codermerlin.com/resources/BlueRobotWithHat.png")
    private let image: Image
    private let beeperText: Text
    private var imageLocation: Point? = nil
    private var imageSize: Size? = nil


    private var tweenTranslate: Tween<Point>? = nil
    private var tweenRotate: Tween<Double>? = nil
    
    private(set) var currentGridLocation = GridLocation.one
    private var nextGridLocation = GridLocation.one

    private var didFinishNotification: DidFinishNotification? = nil

    private var currentRotateRadians = 0.0
    private var nextRotateRadians = 0.0

    private(set) var currentDirection = CompassDirection.north
    private var nextDirection = CompassDirection.north

    private var initialGridLocation = GridLocation.one
    private var initialCompassDirection = CompassDirection.north
    private var initialBeeperCount = 0

    private(set) var beeperCount = 0

    private var animationDurationSeconds: Double = Style.standardAnimationDurationSeconds
    
    init() {
        guard let url = url else {
            fatalError("Unable to form url")
        }
        image = Image(sourceURL: url)
        beeperText = Text(location: Point.zero, text: "0")
        beeperText.alignment = .center
        beeperText.baseline = .top

        super.init(name: "Karel")
    }

    func setAnimationDurationSeconds(_ durationSeconds: Double) {
        animationDurationSeconds = durationSeconds
    }

    func setDidFinishNotification(_ didFinishNotification: @escaping DidFinishNotification) {
        self.didFinishNotification = didFinishNotification
    }

    func pointFrom(gridLocation: GridLocation) -> Point {
        guard let world = world,
              let imageSize = imageSize else {
            fatalError("world and imageSize required in pointFrom")
        }
        return world.pointOnGrid(at: gridLocation) - imageSize.center
    }

    func setInitial(gridLocation: GridLocation, compassDirection: CompassDirection, beeperCount: Int) {
        initialGridLocation = gridLocation
        initialCompassDirection = compassDirection
        initialBeeperCount = beeperCount
    }

    func interactionLayer() -> InteractionLayer {
        guard let layer = layer as? InteractionLayer else {
            fatalError("InteractionLayer required")
        }
        return layer
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(image)

        // Determine image size
        let size = min(canvasSize.width, canvasSize.height) / 10
        imageSize = Size(width: size, height: size)
        imageLocation = pointFrom(gridLocation: currentGridLocation)

        // Determine font size
        let fontSize = size / 6
        beeperText.font = "\(fontSize)pt \(Style.karelBeeperFont)"

        // Set initial location, direction and beeper count
        self.move(to: initialGridLocation)
        self.rotate(to: initialCompassDirection)
        self.beeperCount = initialBeeperCount
    }
    
    override func render(canvas: Canvas) {
        if world != nil {
            if image.isReady {
                canvas.render(image)

                if beeperCount > 0 {
                    canvas.render(Style.karelBeeperTextFillStyle, beeperText)
                }
            }
        }
    }

    override func calculate(canvasSize: Size) {
        guard let imageLocation = imageLocation,
              let imageSize = imageSize else {
            fatalError("world is required to calculate")
        }

        // Set position
        let targetRect = Rect(topLeft: imageLocation, size: imageSize)
        image.renderMode = .destinationRect(targetRect)

        // Rotate as indicated
        let center = DoublePoint(imageLocation + imageSize.center)
        let preTranslate = Transform(translate: center)
        let rotate = Transform(rotateRadians: currentRotateRadians)
        let postTranslate = Transform(translate: -center)
        setTransforms(transforms:[preTranslate, rotate, postTranslate])

        // Set text
        beeperText.text = "\(beeperCount)"
        let textOffset = Point(x: 0, y: imageSize.height / 5)
        beeperText.location = Point(center) + textOffset

        // If we were animating and now completed, clean up and inform our callback (if specified)
        if tweenTranslate?.isCompleted == true {
            tweenTranslate = nil
            currentGridLocation = nextGridLocation
            self.imageLocation = pointFrom(gridLocation: currentGridLocation)

            if let didFinishNotification = didFinishNotification {
                didFinishNotification()
            }
        }

        if tweenRotate?.isCompleted == true {
            tweenRotate = nil
            currentRotateRadians = nextRotateRadians
            currentDirection     = nextDirection

            if let didFinishNotification = didFinishNotification {
                didFinishNotification()
            }
        }
    }

    func rotate(to targetDirection: CompassDirection) {
        currentRotateRadians = targetDirection.rawValue * Double.pi / 180.0
        currentDirection     = targetDirection
        
        nextRotateRadians = currentRotateRadians
        nextDirection     = currentDirection
    }

    func animate(to targetDirection: CompassDirection) {
        guard tweenRotate == nil else {
            fatalError("Requested to animate rotation but animation already in progress")
        }
        nextRotateRadians = targetDirection.rawValue * Double.pi / 180.0
        nextDirection     = targetDirection

        // For north to west, we need to rotate DOWN from Double.pi * 2.0, otherwise we'll animate a 270 deg turn CLOCKWISE
        // The same is true from west to north
        let fromRotation: Double
        let toRotation: Double
        
        switch (currentDirection, targetDirection) {
        case (.north, .west):
            fromRotation = Double.pi * 2.0
            toRotation   = nextRotateRadians
        case (.west, .north):
            fromRotation = currentRotateRadians
            toRotation   = Double.pi * 2.0
        default:
            fromRotation = currentRotateRadians
            toRotation   = nextRotateRadians
        }

        tweenRotate = Tween(from: fromRotation, to: toRotation, duration: animationDurationSeconds, ease: EasingStyle.inCubic) {self.currentRotateRadians = $0}
        animationController.register(animation: tweenRotate!)
        tweenRotate!.play()
    }

    func move(to targetGridLocation: GridLocation) {
        guard let imageSize = imageSize else {
            fatalError("imageSize are required to move")
        }
        imageLocation = pointFrom(gridLocation:targetGridLocation)
        let imageRect = Rect(topLeft: imageLocation!, size: imageSize)
        image.renderMode = .destinationRect(imageRect)

        currentGridLocation = targetGridLocation
        nextGridLocation = targetGridLocation
    }

    func animate(to targetGridLocation: GridLocation) {
        guard tweenTranslate == nil else {
            fatalError("Requested to animate translation but animation already in progress")
        }
        nextGridLocation = targetGridLocation
        let fromPoint = pointFrom(gridLocation: currentGridLocation)
        let toPoint = pointFrom(gridLocation: nextGridLocation)

        tweenTranslate = Tween(from: fromPoint, to: toPoint, duration: animationDurationSeconds, ease: EasingStyle.inCubic) {self.imageLocation = $0}
        animationController.register(animation: tweenTranslate!)
        tweenTranslate!.play()
    }

    func animateForward() {
        switch currentDirection {
        case .north:
            animate(to: GridLocation(avenue: currentGridLocation.avenue, street: currentGridLocation.street + 1))
        case .east:
            animate(to: GridLocation(avenue: currentGridLocation.avenue + 1, street: currentGridLocation.street))
        case .south:
            animate(to: GridLocation(avenue: currentGridLocation.avenue, street: currentGridLocation.street - 1))
        case .west:
            animate(to: GridLocation(avenue: currentGridLocation.avenue - 1, street: currentGridLocation.street))
        }
    }

    func animateTurnLeft() {
        switch currentDirection {
        case .north:
            animate(to: .west)
        case .east:
            animate(to: .north)
        case .south:
            animate(to: .east)
        case .west:
            animate(to: .south)
        }
    }
    
    func animateTurnRight() {
        switch currentDirection {
        case .north:
            animate(to: .east)
        case .east:
            animate(to: .south)
        case .south:
            animate(to: .west)
        case .west:
            animate(to: .north)
        }
    }

    func isFacing(direction: CompassDirection) -> Bool {
        return direction == self.currentDirection
    }

    func addBeeper() {
        beeperCount += 1
    }

    func removeBeeper() {
        guard beeperCount >= 1 else {
            fatalError("karel doesn't have any beepers")
        }
        beeperCount -= 1
    }

}
