import Foundation

func day19(for part: Part) {
    func getInput() -> (patterns: [String], designs: [String]) {
        let parts = try! String(contentsOfFile: path + "/19.txt", encoding: .utf8)
            .split(separator: "\n\n")
        let patterns = parts[0]
            .split(separator: ", ")
            .map { String($0) }
        let designs = parts[1]
            .split(separator: "\n")
            .map { String($0) }
        return (patterns, designs)
    }

    let (patterns, designs) = getInput()

    var memo = [String: Int]()

    func countMatches(_ design: String) -> Int {
        if let cached = memo[design] { return cached }
        guard !design.isEmpty else {
            memo[design] = 1
            return 1
        }
        let numMatches = patterns
            .filter { design.starts(with: $0) }
            .reduce(into: 0) { result, match in
                result += countMatches(String(design.dropFirst(match.count)))
            }
        memo[design] = numMatches
        return numMatches
    }

    let num = designs.map { countMatches($0) }.reduce(0, +)
    print(num)
}
