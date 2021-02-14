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

class Grid: KarelRenderableEntity {
    init() {
        super.init(name: "Grid")
    }

    override func render(canvas: Canvas) {
        guard let world = world else {
            fatalError("world required to begin render")
        }
        canvas.render(Style.gridWidth, Style.streetStrokeStyle, Style.gridTextFillStyle)
        
        // Render streets
        for street in 0 ..< world.streetCount {
            let left = world.pointOnGrid(at: GridLocation(avenue: 0, street: street))
            let right = world.pointOnGrid(at: GridLocation(avenue: world.avenueCount-1, street: street))

            // Render label
            if (1..<world.streetCount - 1).contains(street) {
                let text = Text(location: left - Point(x: Style.worldLeftMargin / 2, y: 0), text: "\(street)")
                text.alignment = .center
                text.baseline = .middle
                text.font = Style.gridFont
                canvas.render(text)
            }

            // Render line
            let lines = Lines(from: left, to: right)
            canvas.render(lines)
        }

        // Render avenues
        canvas.render(Style.gridWidth, Style.avenueStrokeStyle, Style.gridTextFillStyle)
        for avenue in 0 ..< world.avenueCount {
            let top = world.pointOnGrid(at: GridLocation(avenue: avenue, street: world.streetCount - 1))
            let bottom = world.pointOnGrid(at: GridLocation(avenue: avenue, street: 0))

            // Render label
            if (1..<world.avenueCount - 1).contains(avenue) {
                let text = Text(location: bottom + Point(x: 0, y: Style.worldBottomMargin / 2), text: "\(avenue)")
                text.alignment = .center
                text.baseline = .middle
                text.font = Style.gridFont
                canvas.render(text)
            }

            // Render line
            let lines = Lines(from: top, to: bottom)
            canvas.render(lines)
        }

        // Render edges
        let topLeft = world.pointOnGrid(at: GridLocation(avenue: 0, street: world.streetCount - 1))
        let bottomRight = world.pointOnGrid(at: GridLocation(avenue: world.avenueCount - 1, street: 0))
        let size = Size(width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
        let rect = Rect(topLeft: topLeft, size: size)
        let rectangle = Rectangle(rect:rect, fillMode: .stroke)
        canvas.render(Style.edgeWidth, Style.edgeStrokeStyle, rectangle)
    }

}
