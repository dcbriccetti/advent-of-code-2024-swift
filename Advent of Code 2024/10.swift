func day10(for part: Part) async throws {

    let grid = try String(contentsOfFile: path + "/10-test.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { line in
            Array(line).map(\.wholeNumberValue!)
        }
    let allCoordinatePairs: [CoordPair] = (0..<grid.count).flatMap { rowIndex in
        (0..<grid[0].count).map { colIndex in CoordPair(y: rowIndex, x: colIndex) }
    }
    let trailheads = allCoordinatePairs.filter { pair in
        grid[pair.y][pair.x] == 0
    }

    let neighborDeltas = [ // Search in 8 directions
        (-1, -1), (-1,  0), (-1, +1),
        ( 0, -1), /* 🔎 */  ( 0, +1),
        (+1, -1), (+1,  0), (+1, +1)
    ]

    func cellsAround(_ coord: CoordPair) -> [CoordPair] {
        return []
    }

    print(trailheads)
}


