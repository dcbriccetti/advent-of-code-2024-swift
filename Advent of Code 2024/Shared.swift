import Foundation

let path = "/Users/daveb/devel/Advent-of-Code/AOC-2024/Advent of Code 2024/data/"

enum Part {
    case part1
    case part2
}

struct Vector: Hashable, CustomStringConvertible {
    let y: Int
    let x: Int
    let xyOrder: Bool

    init(y: Int, x: Int) {
        self.y = y
        self.x = x
        self.xyOrder = false
    }

    init(x: Int, y: Int) {
        self.y = y
        self.x = x
        self.xyOrder = true
    }

    var description: String { xyOrder ? "(x: \(x), y: \(y))" : "(y: \(y), x: \(x))" }

    static func + (left: Vector, right: Vector) -> Vector {
        return Vector(y: left.y + right.y, x: left.x + right.x)
    }

    static func - (left: Vector, right: Vector) -> Vector {
        return Vector(y: left.y - right.y, x: left.x - right.x)
    }

    static func * (left: Vector, right: Vector) -> Vector {
        return Vector(y: left.y * right.y, x: left.x * right.x)
    }

    static func += (left: inout Vector, right: Vector) {
        left = left + right
    }

    static prefix func - (coord: Vector) -> Vector {
        return Vector(y: -coord.y, x: -coord.x)
    }

    func validIn(height: Int, width: Int) -> Bool {
        y >= 0 && x >= 0 && y < height && x < width
    }
}

// Read a file and parse its contents into a 2D array of Ints
func readFileTo2DArray(from filename: String) throws -> [[Int]] {
    let fileContents = try String(contentsOfFile: filename, encoding: .utf8)
    
    // Split the file into lines, then split each line into numbers
    return fileContents
        .split(separator: "\n")
        .map { line in
            line
                .split(separator: " ")
                .compactMap { Int($0) }
        }
}

func extractAndSortColumns(from data: [[Int]]) -> ([Int], [Int]) {
    (data.map { $0[0] }.sorted(), data.map { $0[1] }.sorted())
}
