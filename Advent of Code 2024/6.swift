func day6(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/6.txt", encoding: .utf8)
    let lines = data.split(separator: "\n")
    let numRows = lines.count
    let numCols = lines.first!.count

    struct CoordPair: Hashable {
        let y: Int
        let x: Int
    }

    enum Direction: Int, CaseIterable {
        case up, right, down, left

        func toRight() -> Direction {
            return Direction(rawValue: (self.rawValue + 1) % Direction.allCases.count)!
        }
    }

    struct Visit: Hashable {
        let pos: CoordPair
        let direction: Direction
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
    var direction = Direction.up
    var visited = Set<Visit>()

    while true {
        let visit = Visit(pos: guardPosition, direction: direction)
        if visited.contains(visit) {
            print("Found loop")
            break
        }
        visited.insert(visit)
        let nextRowIndex = guardPosition.y + deltas[direction.rawValue].0
        let nextColIndex = guardPosition.x + deltas[direction.rawValue].1
        if nextRowIndex < 0 || nextRowIndex >= numRows || nextColIndex < 0 || nextColIndex >= numCols {
            break
        }
        let nextPos = CoordPair(y: nextRowIndex, x: nextColIndex)
        if obstacles.contains(nextPos) {
            direction = direction.toRight()
        } else {
            guardPosition = nextPos
        }
    }
    print(Set(visited.map(\.pos)).count)
}
