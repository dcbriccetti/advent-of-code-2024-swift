extension Collection {
    /// Returns consecutive pairs of elements in the collection.
    func pairwise() -> [(Element, Element)] {
        Array(zip(self, self.dropFirst()))
    }
}

/// Helper function to check if a report is valid based on its deltas.
func isValid(deltas: [Int]) -> Bool {
    deltas.allSatisfy { abs($0) <= 3 } &&
    (deltas.allSatisfy { $0 < 0 } || deltas.allSatisfy { $0 > 0 })
}

func isReportValid(_ report: [Int], for part: Part) -> Bool {
    // Compute deltas and check validity
    let deltas: [Int] = report.pairwise().map { $1 - $0 }
    if isValid(deltas: deltas) {
        return true
    }

    if part == .part1 {
        return false // No retries
    }

    // For part 2, retry with modified arrays
    for i in 0..<report.count {
        let modifiedReport = report[0..<i] + report[(i + 1)...]
        let modifiedDeltas: [Int] = modifiedReport.pairwise().map { $1 - $0 }
        if isValid(deltas: modifiedDeltas) {
            return true
        }
    }

    return false
}

func day2(for part: Part) throws {
    let reports: [[Int]] = try readFileTo2DArray(from: path + "2-test.txt")
    let numValid: Int = reports.reduce(0) { count, report in
        count + (isReportValid(report, for: part) ? 1 : 0)
    }

    print("Number of valid reports:", numValid)
}
