import Scenes
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

class Wall: KarelRenderableEntity {
    private let wallLocation: WallLocation
    private let rectangle: Rectangle

    init(wallLocation: WallLocation) {
        self.wallLocation = wallLocation
        self.rectangle = Rectangle(rect: Rect.zero, fillMode: .fillAndStroke)
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        guard let world = world else {
            fatalError("world required for setup")
        }

        let intersection = world.pointOnGrid(at: wallLocation.gridLocation)
        let isHorizontal = wallLocation.side == .above

        if isHorizontal {
            let size = Size(width: world.pixelsBetweenAvenues, height: Style.wallThickness)
            let verticalOffset = -world.pixelsBetweenStreets / 2 - size.height / 2
            rectangle.rect.topLeft = Point(x: intersection.x - size.width / 2,
                                           y: intersection.y + verticalOffset)
            rectangle.rect.size = size
        } else {
            // The vertical walls intentionally overlap the horizontal walls for aesthetic reasons
            let size = Size(width: Style.wallThickness, height: world.pixelsBetweenStreets + Style.wallThickness)
            let horizontalOffset = +world.pixelsBetweenAvenues / 2 - size.width / 2
            rectangle.rect.topLeft = Point(x: intersection.x + horizontalOffset,
                                           y: intersection.y - world.pixelsBetweenStreets / 2 - Style.wallThickness / 2)
            rectangle.rect.size = size
        }
    }

    override func render(canvas: Canvas) {
        canvas.render(Style.wallStrokeStyle, Style.wallFillStyle, rectangle)
    }
}
