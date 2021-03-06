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

class BackgroundLayer : Layer {
    let background: Background
    let grid = Grid()

    init(color: Color) {
        background = Background(color: color)
        
        super.init(name:"Background")

        insert(entity:background, at:.back)
        insert(entity:grid, at:.front)
    }
}
