func day10(for part: Part) throws {

    let grid = try String(contentsOfFile: path + "/10-test.txt", encoding: .utf8)
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

    func climb(from location: CoordPair, collecting topLocs: inout Set<CoordPair>) {
        let heightHere = grid[location.y][location.x]
        if heightHere == 9 {
            topLocs.insert(location)
            return
        }
        let nextHeight = heightHere + 1
        let nexts = cellsAround(location).filter { grid[$0.y][$0.x] == nextHeight }
        for next in nexts {
            climb(from: next, collecting: &topLocs)
        }
    }

    let total = trailheads.map { trailhead in
        var topLocs = Set<CoordPair>()
        climb(from: trailhead, collecting: &topLocs)
        return topLocs.count
    }.reduce(0, +)

    print("Total trailhead scores: \(total)")
}


