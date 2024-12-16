func day8(for part: Part) throws {
    let lines = try String(contentsOfFile: path + "/8.txt", encoding: .utf8)
        .split(separator: "\n")
    let numRows = lines.count
    let numCols = lines[0].count

    let groupedNodes: [Character: [Vector]] = Dictionary(grouping: lines.enumerated().flatMap { (rowIndex, line) in
        Array(line).enumerated()
            .compactMap { (colIndex, cell) in
                cell == "." ? nil : (cell, Vector(y: rowIndex, x: colIndex))
            }
    }, by: { $0.0 })
        .mapValues { $0.map { $0.1 } }

    func makeAntinodes(p1: Vector, p2: Vector) -> [Vector] {
        let Δ12 = Vector(y: p2.y - p1.y, x: p2.x - p1.x)
        let Δ21 = -Δ12
        if part == .part1 {
            return [p1 - Δ12, p2 + Δ12]
        }

        return [Δ12, Δ21].flatMap { Δ in
            (0...).lazy.map { p1 + Δ * Vector(y: $0, x: $0) }
                .prefix { $0.validIn(height: numRows, width: numCols) }
        }
    }

    let antinodes: [Vector] = groupedNodes.flatMap { (_, coordPairs) in
        let allPairs: [(Vector, Vector)] = coordPairs.indices.flatMap { i in
            coordPairs[(i + 1)...].map { (coordPairs[i], $0) }
        }

        return allPairs.flatMap { makeAntinodes(p1: $0.0, p2: $0.1) }
    }

    func displayAntinodes(_ antinodes: [Vector]) {
        let output = (0..<numRows).map { r in
            (0..<numCols).map { c in
                antinodes.contains(Vector(y: r, x: c)) ? "#" : "."
            }.joined()
        }.joined(separator: "\n")
        print(output)
    }

    print(Set(antinodes).count)
    displayAntinodes(antinodes)
}
