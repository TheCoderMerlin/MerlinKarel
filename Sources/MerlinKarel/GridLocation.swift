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

public struct GridLocation: Hashable, Comparable, CustomStringConvertible {
    let avenue: Int
    let street: Int

    public init(avenue:Int, street: Int) {
        self.avenue = avenue
        self.street = street
    }

    static let one = GridLocation(avenue: 1, street: 1)
    
    public static func < (lhs: GridLocation, rhs: GridLocation) -> Bool {
        return (lhs.avenue, lhs.street) < (rhs.avenue, rhs.street)
    }

    public var description: String {
        return "(avenue: \(avenue), street: \(street))"
    }
}
