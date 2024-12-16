func day8(for part: Part) throws {
    let lines = try String(contentsOfFile: path + "/8.txt", encoding: .utf8)
        .split(separator: "\n")
    let numRows = lines.count
    let numCols = lines[0].count

    let antennaGroups: [Character: [Vector]] = Dictionary(grouping: lines.enumerated().flatMap { (rowIndex, line) in
        Array(line).enumerated()
            .compactMap { (colIndex, cell) in
                cell == "." ? nil : (cell, Vector(y: rowIndex, x: colIndex))
            }
    }, by: { $0.0 })
        .mapValues { $0.map { $0.1 } }

    func makeAntinodes(antenna1: Vector, antenna2: Vector) -> [Vector] {
        let Δ12 = Vector(y: antenna2.y - antenna1.y, x: antenna2.x - antenna1.x)
        let Δ21 = -Δ12
        if part == .part1 {
            return [antenna1 - Δ12, antenna2 + Δ12]
        }

        return [Δ12, Δ21].flatMap { Δ in
            (0...).lazy.map { antenna1 + Δ * Vector(y: $0, x: $0) }
                .prefix { $0.validIn(height: numRows, width: numCols) }
        }
    }

    let antinodeLocations: [Vector] = antennaGroups.flatMap { (_, locations) in
        let allAntennaPairs: [(Vector, Vector)] = locations.indices.flatMap { i in
            locations[(i + 1)...].map { (locations[i], $0) }
        }

        return allAntennaPairs.flatMap { makeAntinodes(antenna1: $0.0, antenna2: $0.1) }
    }

    func displayAntinodes(_ antinodes: [Vector]) {
        let display = (0..<numRows).map { r in
            (0..<numCols).map { c in
                antinodes.contains(Vector(y: r, x: c)) ? "#" : "."
            }.joined()
        }.joined(separator: "\n")
        print(display)
    }

    print(Set(antinodeLocations).count)
    displayAntinodes(antinodeLocations)
}
