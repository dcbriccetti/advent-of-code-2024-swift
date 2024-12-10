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
    let grid: [[Character]] = try String(contentsOfFile: path + "/4-test.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { Array($0) }
    let allCoordinatePairs: [(Int, Int)] = (0..<grid.count).flatMap { rowIndex in
        (0..<grid[0].count).map { colIndex in (rowIndex, colIndex) }
    }
    
    let (numStringMatches, part2MatchCenterCoordHashes) = allCoordinatePairs.reduce((0, [Int]())) { (acc, coordPair) in
        var (numStringMatches, hashes) = acc
        let (rowIndex, colIndex) = coordPair
        let ch = grid[rowIndex][colIndex]
        if ch == searchChars[0] {
            // Found start of string. Let’s follow the deltas in each direction to see if there’s a match
            for neighborDelta in neighborDeltas {
                var searchStringIndex = 1
                var matching = true
                while matching && searchStringIndex < searchChars.count {
                    let searchRowIndex = rowIndex + neighborDelta.0 * searchStringIndex
                    let searchColIndex = colIndex + neighborDelta.1 * searchStringIndex
                    let indexesOk = searchRowIndex >= 0 && searchRowIndex < grid.count &&
                        searchColIndex >= 0 && searchColIndex < grid[0].count
                    if indexesOk && grid[searchRowIndex][searchColIndex] == searchChars[searchStringIndex] {
                        searchStringIndex += 1
                    } else {
                        matching = false
                    }
                }
                if matching {
                    numStringMatches += 1
                    if part == .part2 {
                        hashes.append((rowIndex + neighborDelta.0) * grid[0].count + (colIndex + neighborDelta.1))
                    }
                }
            }
        }
        return (numStringMatches, hashes)
    }
    
    print("Found \(numStringMatches) matches")
    
    if part == .part2 {
        let numUnique = Set(part2MatchCenterCoordHashes).count
        let numXmas = part2MatchCenterCoordHashes.count - numUnique
        print("Found X-MAS \(numXmas) times")
    }
}
