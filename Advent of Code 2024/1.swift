func day1() throws {
    let data: [[Int]] = try readFileTo2DArray(from: path + "1-test.txt")
    let (col1, col2) = (data.map { $0[0] }.sorted(), data.map { $0[1] }.sorted())
    let differences = zip(col1, col2).map { abs($0 - $1) }
    let sumOfDifferences = differences.reduce(0, +)
    print("Sum of Differences:", sumOfDifferences)

    let similarityScore = col1.reduce(0) { score, col1Num in
        let numMatches = col2.reduce(0) { $0 + ($1 == col1Num ? 1 : 0) }
        return score + numMatches * col1Num
    }

    print("Similarity Score:", similarityScore)
}
