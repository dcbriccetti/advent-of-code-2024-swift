func day3(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/3.txt", encoding: .utf8)
    let matches = data.matches(of: /mul\((\d+)\,(\d+)\)|(do\(\))|(don't\(\))/)
    var enabled = true

    let sum = matches.compactMap { match -> Int? in
        if match.0.starts(with: "don") && part == .part2 {
            enabled = false
            return nil
        } else if match.0.starts(with: "do") {
            enabled = true
            return nil
        } else if enabled && match.0.starts(with: "mul") {
            return Int(match.1!)! * Int(match.2!)!
        } else {
            return nil
        }
    }.reduce(0, +)

    print(sum)
}
