func day4(for part: Part) throws {
    let searchChars = Array(part == .part1 ? "XMAS" : "MAS")
    let neighborDeltas = part == .part1 ? [ // Search in 8 directions if part 1
        (-1, -1), (-1,  0), (-1, +1),
        ( 0, -1), /* 🔎 */  ( 0, +1),
        (+1, -1), (+1,  0), (+1, +1)
    ] : [                                   // Search in 4 directions if part 2
        (-1, -1),           (-1, +1),
                  /* 🔎 */
        (+1, -1),           (+1, +1)
    ]
    let grid: [[Character]] = try String(contentsOfFile: path + "/4.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { Array($0) }
    let allCoordinatePairs: [(Int, Int)] = (0..<grid.count).flatMap { rowIndex in
        (0..<grid[0].count).map { colIndex in (rowIndex, colIndex) }
    }
    var numStringMatches = 0
    var part2MatchCenterCoordHashes: [Int] = []
    for (rowIndex, colIndex) in allCoordinatePairs {
        let ch = grid[rowIndex][colIndex]
        if ch == searchChars[0] {
            // Found start of string. Let’s follow the deltas in each direction to see if there’s a match
            for neighborDelta in neighborDeltas {
                var searchStringIndex = 1
                var matching = true
                while matching && searchStringIndex < searchChars.count {
                    let iSearchRow = rowIndex + neighborDelta.0 * searchStringIndex
                    let iSearchCol = colIndex + neighborDelta.1 * searchStringIndex
                    let indexesValid: Bool = iSearchRow >= 0 && iSearchRow < grid.count && iSearchCol >= 0 && iSearchCol < grid[0].count
                    if indexesValid && grid[iSearchRow][iSearchCol] == searchChars[searchStringIndex] {
                        searchStringIndex += 1
                    } else {
                        matching = false
                    }
                }
                if matching {
                    numStringMatches += 1
                    if part == .part2 {
                        part2MatchCenterCoordHashes.append((rowIndex + neighborDelta.0) * grid[0].count + (colIndex + neighborDelta.1))
                    }
                }
            }
        }
    }
    print("Found \(numStringMatches) matches")
    if part == .part2 {
        let numUnique = Set(part2MatchCenterCoordHashes).count
        let numXmas = part2MatchCenterCoordHashes.count - numUnique
        print("Found X-MAS \(numXmas) times")
    }
}
