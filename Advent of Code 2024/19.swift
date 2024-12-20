import Foundation

func day19(for part: Part) {
    func getInput() -> (patterns: [String], designs: [String]) {
        let parts = try! String(contentsOfFile: path + "/19-test.txt", encoding: .utf8)
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

    var memo = [String: Bool]()

    func canMatch(_ design: String) -> Bool {
        if let cached = memo[design] { return cached }
        if design.isEmpty {
            memo[design] = true
            return true
        }
        let matches = patterns.filter { design.starts(with: $0) }
        let mb = matches.map { match in
            canMatch(String(design.dropFirst(match.count)))
        }
        let foundMatch = mb.contains(true)
        memo[design] = foundMatch
        return foundMatch
    }

    let num = designs.compactMap { canMatch($0) ? 1 : nil }.count
    print(num)
}
