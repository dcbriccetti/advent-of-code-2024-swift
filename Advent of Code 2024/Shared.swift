import Foundation

let path = "/Users/daveb/devel/Advent-of-Code/AOC-2024/Advent of Code 2024/data/"

enum Part {
    case part1
    case part2
}

struct CoordPair: Hashable {
    let y: Int
    let x: Int
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
