func day4(for part: Part) throws {
    let searchChars = Array("XMAS")
    let neighborDeltas = [
        (-1, -1), (-1,  0), (-1, +1),
        ( 0, -1),           ( 0, +1),
        (+1, -1), (+1,  0), (+1, +1)
    ]
    var numFinds = 0
    let grid: [[Character]] = try String(contentsOfFile: path + "/4-test.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { Array($0) }
    let allCoordinatePairs: [(Int, Int)] = (0..<grid.count).flatMap { rowIndex in
        (0..<grid[0].count).map { colIndex in (rowIndex, colIndex) }
    }
    for (iRow, iCol) in allCoordinatePairs {
        let ch = grid[iRow][iCol]
        if ch == searchChars[0] {
            // Found start of string. Let’s follow the deltas in each direction to see if there’s a match
            for neighborDelta in neighborDeltas {
                var iSearch = 1
                var matching = true
                while matching && iSearch < searchChars.count {
                    let iSearchRow = iRow + neighborDelta.0 * iSearch
                    let iSearchCol = iCol + neighborDelta.1 * iSearch
                    let indexesValid: Bool = iSearchRow >= 0 && iSearchRow < grid.count && iSearchCol >= 0 && iSearchCol < grid[0].count
                    if indexesValid && grid[iSearchRow][iSearchCol] == searchChars[iSearch] {
                        iSearch += 1
                    } else {
                        matching = false
                    }
                }
                if matching {
                    numFinds += 1
                }
            }
        }
    }
    print("Found \(numFinds) matches")
}
