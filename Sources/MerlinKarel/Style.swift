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

class Style {
    // Background colors
    static let initialBackgroundColor = Color(.aliceblue)
    static let goalBackgroundColor = Color(.darkgoldenrod)
    
    // Margins between the 'world' and the browser's edge
    static let worldLeftMargin = 50
    static let worldRightMargin = 50
    static let worldTopMargin = 50
    static let worldBottomMargin = 50

    // Grid and edge styles
    static let edgeStrokeStyle = StrokeStyle(color: Color(.black))
    static let streetStrokeStyle = StrokeStyle(color: Color(.blue))
    static let avenueStrokeStyle = StrokeStyle(color: Color(.green))

    static let edgeWidth = LineWidth(width: 5)
    static let gridWidth = LineWidth(width: 3)
    
    static let gridTextFillStyle = FillStyle(color: Color(.darkslategray))
    static let gridFont = "30pt Arial"

    static let standardAnimationDurationSeconds = 1.0
    static let merlinMissionManagerAnimationDurationSeconds = 0.0

    // Beepers
    static let beeperStrokeStyle = StrokeStyle(color: Color(.orange))
    static let beeperGradientCenterColor   = Color(.red)
    static let beeperGradientEdgeColor     = Color(.orange)
    
    static let beeperTextFillStyle         = FillStyle(color: Color(.black))
    static let beeperFont                  = "20pt Courier"

    // Karel
    static let karelBeeperTextFillStyle = FillStyle(color: Color(.white))
    static let karelBeeperFont = "Courier" // size determined dynamically
}
