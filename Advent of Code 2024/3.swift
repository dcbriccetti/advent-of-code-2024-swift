func day3(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/3-test.txt", encoding: .utf8)
    let matches = data.matches(of: /mul\((\d+)\,(\d+)\)|(do\(\))|(don't\(\))/)
    var insideDont = false
    let sum = matches.compactMap { match -> Int? in
        let includeThisMul = part == .part1 || !insideDont
        if includeThisMul && match.0.starts(with: "mul") {
            return Int(match.1!)! * Int(match.2!)!
        }
        if match.0.starts(with: "don't(") {
            insideDont = true
        } else if match.0.starts(with: "do(") {
            insideDont = false
        }
        return nil
    }.reduce(0, +)

    print(sum)
}
