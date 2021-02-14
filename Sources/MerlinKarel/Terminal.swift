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

class Terminal {

    static let escape = "\u{1B}"
    static let crlf = "\r\n"

    enum LineBoxLightType : String {
        case topLeftCorner         = "\u{250C}"
        case horizontal            = "\u{2500}"
        case horizontalDownCenter  = "\u{252C}"
        case topRightCorner        = "\u{2510}"
        case vertical              = "\u{2502}"

        case bottomLeftCorner      = "\u{2514}"
        case horizontalUpCenter    = "\u{2534}"
        case bottomRightCorner     = "\u{2518}"
    }

    enum Color : String {
        case black    =  "0"
        case maroon   =  "1"
        case green    =  "2"
        case olive    =  "3"
        case navy     =  "4"
        case purple   =  "5"
        case teal     =  "6"
        case silver   =  "7"
        case grey     =  "8"
        case red      =  "9"
        case lime     = "10"
        case yellow   = "11"
        case blue     = "12"
        case fuchsia  = "13"
        case aqua     = "14"
        case white    = "15"

        // Extended colors
        case amber    = "208"

    }

    enum Ground : String {
        case fore = "38"
        case back = "48"
    }

    static func reset() -> String {
        return "\(escape)[0m"
    }

    static func normal() -> String {
        return "\(escape)[22m"
    }

    static func bold() -> String {
        return "\(escape)[1m"
    }

    static func dim() -> String {
        return "\(escape)[2m"
    }

    static func underline() -> String {
        return "\(escape)[4m"
    }

    static func blink() -> String {
        return "\(escape)[5m"
    }

    static func reverse() -> String {
        return "\(escape)[7m"
    }

    static func reverseOff() -> String {
        return "\(escape)[27m"
    }

    static func setColor(_ color:Color, _ ground:Ground) -> String
    {
        return "\(escape)[\(ground.rawValue);5;\(color.rawValue)m"
    }

    static func lineBoxLight(_ lineBoxLightType:LineBoxLightType, count:Int = 1) -> String {
        return String(repeating:lineBoxLightType.rawValue, count: count)
    }

}
