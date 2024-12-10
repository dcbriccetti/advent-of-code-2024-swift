func day5(for part: Part) throws {
    let (prerequisitesByPageNum, updates) = try getData()

    func prerequisitesCount(for pageNum: String, in update: [String]) -> Int {
        prerequisitesByPageNum[pageNum, default: []].filter(update.contains).count
    }

    let totalMiddlePageNumbers = updates.reduce(0) { (total, update) in
        let allPrereqs: [(String, Int)] = update.map { pageNum in
            (pageNum, prerequisitesCount(for: pageNum, in: update))
        }
        let sortedPrereqs = allPrereqs.sorted { $0.1 < $1.1 }
        let pageNumbersInOrder = sortedPrereqs.map(\.0)
        let updateOk = pageNumbersInOrder == update
        if (updateOk && part == .part1) || (!updateOk && part == .part2) {
            let sequence = part == .part1 ? update : pageNumbersInOrder
            if let middlePageNumber = Int(sequence[sequence.count / 2]) {
                return total + middlePageNumber
            }
        }
        return total
    }
    print(totalMiddlePageNumbers)
}

func getData() throws -> (prerequisitesByPageNum: [String : Set<String>], updates: [[String]]) {
    let data = try String(contentsOfFile: path + "/5.txt", encoding: .utf8)
    let sections = data.split(separator: "\n\n")
    let prerequisitesByPageNum: [String : Set<String>] = sections[0].split(separator: "\n")
        .map { line in line.split(separator: "|").map { String($0) } }
        .reduce(into: [String: Set<String>]()) { (dict, prereq_pair) in
            let pageNum: String = prereq_pair[1]
            let mustPrecedePageNum: String = prereq_pair[0]
            dict[pageNum, default: []].insert(mustPrecedePageNum)
        }
    let updates: [[String]] = sections[1].split(separator: "\n").map { section in
        section.split(separator: ",").map { String($0) }
    }
    return (prerequisitesByPageNum, updates)
}
