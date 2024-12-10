func day5(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/5.txt", encoding: .utf8)
    let sections = data.split(separator: "\n\n")
    let prereqs: [[String]] = sections[0].split(separator: "\n").map { line in
        line.split(separator: "|").map { update in String(update)}
    }
    let prerequisitesByPageNum = prereqs.reduce(into: [String: Set<String>]()) { (dict, prereq) in
        dict[prereq[1], default: []].insert(prereq[0])
    }
    let updates: [[String]] = sections[1].split(separator: "\n").map { section in
        section.split(separator: ",").map { update in String(update)}
    }
    let totalMiddlePageNumbers = updates.reduce(0) { (acc, update) in
        let updatePages = Set<String>(update)
        var encounteredPageNumbers = Set<String>()
        print(update)
        var updateOk = true
        for pageNum in update {
            if let pagePrereqs = prerequisitesByPageNum[pageNum] {
                let relevantPrereqs = pagePrereqs.filter(updatePages.contains)
                if !relevantPrereqs.allSatisfy(encounteredPageNumbers.contains) {
                    updateOk = false
                }
            }
            encounteredPageNumbers.insert(pageNum)
        }
        print(updateOk ? "OK" : "NOT OK")
        if updateOk {
            let middleIndex: Int = update.count / 2
            let middlePageNumber = Int(update[middleIndex])!
            return acc + middlePageNumber
        } else {
            return acc
        }
    }
    
    print(totalMiddlePageNumbers)
}
