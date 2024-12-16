func day8(for part: Part) throws {
    let lines = try String(contentsOfFile: path + "/8.txt", encoding: .utf8)
        .split(separator: "\n")
    let numRows = lines.count
    let numCols = lines[0].count

    let groupedNodes: [Character: [CoordPair]] = Dictionary(grouping: lines.enumerated().flatMap { (rowIndex, line) in
        Array(line).enumerated()
            .compactMap { (colIndex, cell) in
                cell == "." ? nil : (cell, CoordPair(y: rowIndex, x: colIndex))
            }
    }, by: { $0.0 })
        .mapValues { $0.map { $0.1 } }

    func makeAntinodes(p1: CoordPair, p2: CoordPair) -> [CoordPair] {
        let Δ12 = CoordPair(y: p2.y - p1.y, x: p2.x - p1.x)
        let Δ21 = -Δ12
        if part == .part1 {
            return [p1 - Δ12, p2 + Δ12]
        }

        return [Δ12, Δ21].flatMap { Δ in
            (0...).lazy.map { p1 + Δ * CoordPair(y: $0, x: $0) }
                .prefix { $0.validIn(height: numRows, width: numCols) }
        }
    }

    let antinodes: [CoordPair] = groupedNodes.flatMap { (_, coordPairs) in
        let allPairs: [(CoordPair, CoordPair)] = coordPairs.indices.flatMap { i in
            coordPairs[(i + 1)...].map { (coordPairs[i], $0) }
        }

        return allPairs.flatMap { makeAntinodes(p1: $0.0, p2: $0.1) }
    }

    func displayAntinodes(_ antinodes: [CoordPair]) {
        for r in 0..<numRows {
            for c in 0..<numCols {
                print(antinodes.contains(CoordPair(y: r, x: c)) ? "#" : ".", terminator: "")
            }
            print()
        }
        print()
    }

    print(Set(antinodes).count)
    displayAntinodes(antinodes)
}
