func day6(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/6.txt", encoding: .utf8)
    let lines = data.split(separator: "\n")
    let numRows = lines.count
    let numCols = lines.first!.count

    enum Direction: Int, CaseIterable {
        case up, right, down, left

        func toRight() -> Direction {
            return Direction(rawValue: (self.rawValue + 1) % Direction.allCases.count)!
        }
    }

    struct Visit: Hashable {
        let pos: Vector
        let direction: Direction
    }

    let (startingGuardPosition, obstacles) = lines.enumerated()
        .reduce(into: (guardPos: Vector(y: 0, x: 0), obstacles: Set<Vector>())) { result, row in
            let (rowIndex, line) = row
            Array(line).enumerated().forEach { colIndex, ch in
                let pos = Vector(y: rowIndex, x: colIndex)
                if ch == "^" {
                    result.guardPos = pos
                } else if ch == "#" {
                    result.obstacles.insert(pos)
                }
            }
        }

    let deltas = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    // generate all possible CoordPairs, not including where the guard is
    let pairs = Array(0..<numRows).flatMap { row in
        Array(0..<numCols).compactMap { col in
            let p = Vector(y: row, x: col)
            return startingGuardPosition != p ? p : nil
        }
    }
    let obstacleSets: [Set<Vector>] = part == .part1 ? [obstacles] :
    pairs.map { pair in
        obstacles.union([Vector(y: pair.y, x: pair.x)])
    }

    var loops = 0
    for obstacleSet in obstacleSets {
        var guardPosition = startingGuardPosition
        var direction = Direction.up
        var visited = Set<Visit>()
        while true {
            let visit = Visit(pos: guardPosition, direction: direction)
            if visited.contains(visit) {
                loops += 1
                break
            }
            visited.insert(visit)
            let nextRowIndex = guardPosition.y + deltas[direction.rawValue].0
            let nextColIndex = guardPosition.x + deltas[direction.rawValue].1
            if nextRowIndex < 0 || nextRowIndex >= numRows || nextColIndex < 0 || nextColIndex >= numCols {
                break
            }
            let nextPos = Vector(y: nextRowIndex, x: nextColIndex)
            if obstacleSet.contains(nextPos) {
                direction = direction.toRight()
            } else {
                guardPosition = nextPos
            }
        }
        if part == .part1 {
            print("Visited: \(Set(visited.map(\.pos)).count)")
        }
    }
    if part == .part2 {
        print("Loops: \(loops)")
    }
}
