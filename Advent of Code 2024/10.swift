func day10(for part: Part) throws {
    let grid = try String(contentsOfFile: path + "/10.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { line in
            Array(line).map(\.wholeNumberValue!)
        }
    let numRows = grid.count
    let numCols = grid[0].count
    let allCoordinatePairs: [CoordPair] = (0..<grid.count).flatMap { rowIndex in
        (0..<grid[0].count).map { colIndex in CoordPair(y: rowIndex, x: colIndex) }
    }
    let trailheads: [CoordPair] = allCoordinatePairs.filter { pair in
        grid[pair.y][pair.x] == 0
    }

    let neighborDeltas = [ // Search in 4 directions (horizontally and vertically)
                  (-1,  0),
        ( 0, -1), /* 🔎 */  ( 0, +1),
                  (+1,  0),
    ].map { CoordPair(y: $0.0, x: $0.1) }

    func cellsAround(_ coord: CoordPair) -> [CoordPair] {
        return neighborDeltas.compactMap { delta in
            let newCoord = coord.plus(coordPair: delta)
            return newCoord.validIn(height: numRows, width: numCols) ? newCoord : nil
        }
    }

    func climb(from location: CoordPair, collecting topLocs: inout [CoordPair]) {
        let heightHere = grid[location.y][location.x]
        if heightHere == 9 {
            topLocs.append(location)
            return
        }
        let nextHeight = heightHere + 1
        let nexts = cellsAround(location).filter { grid[$0.y][$0.x] == nextHeight }
        for next in nexts {
            climb(from: next, collecting: &topLocs)
        }
    }

    let (sumNumPaths, sumNumUniqueTrailends) = trailheads.map { trailhead in
        var topLocs = [CoordPair]()
        climb(from: trailhead, collecting: &topLocs)
        let numPaths = topLocs.count
        let numUniqueTrailends = Set(topLocs).count
        return (numPaths, numUniqueTrailends)
    }.reduce((0, 0)) { (result, pair) in
        (result.0 + pair.0, result.1 + pair.1)
    }

    print("Total trailhead scores: \(sumNumPaths), \(sumNumUniqueTrailends)")
}
