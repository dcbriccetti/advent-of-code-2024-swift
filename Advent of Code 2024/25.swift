func day25() {
    struct Piece { // A lock or key
        let heights: [Int]

        func fits(_ other: Piece) -> Bool {
            let sums = zip(heights, other.heights).map(+)
            return sums.allSatisfy { $0 <= 5 } // All will be <= 5 if no overlap
        }
    }

    func getData() -> (locks: [Piece], keys: [Piece]) {
        let data = try! String(contentsOfFile: path + "/25-test.txt", encoding: .utf8)
        let blocks: [String.SubSequence] = data.split(separator: "\n\n")

        return blocks.reduce(into: (locks: [Piece](), keys: [Piece]())) { (result, block) in
            let heights = block.split(separator: "\n")
                .map { Array($0) }
                .reduce(into: [Int](repeating: -1, count: 5)) { (counts, chars) in
                    for i in 0...4 where chars[i] == "#" {
                        counts[i] += 1
                    }
                }
            let piece = Piece(heights: heights)
            switch block.first {
            case "#": result.locks.append(piece)
            default:  result.keys.append(piece)
            }
        }
    }

    let (locks, keys) = getData()
    let matches = locks.flatMap { lock in
        keys.filter { $0.fits(lock) }
    }.count

    print(matches)
}
