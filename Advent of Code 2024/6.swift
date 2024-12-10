func day6(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/6.txt", encoding: .utf8)
    let lines = data.split(separator: "\n")
    let numRows = lines.count
    let numCols = lines.first!.count

    struct CoordPair: Hashable {
        let y: Int
        let x: Int
    }

    let (startingGuardPosition, obstacles) = lines.enumerated()
        .reduce(into: (guardPos: CoordPair(y: 0, x: 0), obstacles: Set<CoordPair>())) { result, row in
        let (rowIndex, line) = row
        Array(line).enumerated().forEach { colIndex, ch in
            let pos = CoordPair(y: rowIndex, x: colIndex)
            if ch == "^" {
                result.guardPos = pos
            } else if ch == "#" {
                result.obstacles.insert(pos)
            }
        }
    }
    var guardPosition = startingGuardPosition

    let deltas = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    var direction = 0
    var visited = Set<CoordPair>()

    while true {
        visited.insert(guardPosition)
        let nextRowIndex = guardPosition.y + deltas[direction].0
        let nextColIndex = guardPosition.x + deltas[direction].1
        if nextRowIndex < 0 || nextRowIndex >= numRows || nextColIndex < 0 || nextColIndex >= numCols {
            break
        }
        let nextPos = CoordPair(y: nextRowIndex, x: nextColIndex)
        if obstacles.contains(nextPos) {
            direction = (direction + 1) % deltas.count
        } else {
            guardPosition = nextPos
        }
    }
    print(visited.count)
}
