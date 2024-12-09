func day3(for part: Part) throws {
    let data = try String(contentsOfFile: path + "/3-test.txt", encoding: .utf8)
    let matches = data.matches(of: /mul\((\d+)\,(\d+)\)|(do\(\))|(don't\(\))/)
    var insideDont = false
    let sum = matches.compactMap { match -> Int? in
        if match.0.starts(with: "mul") {
            return part == .part1 || !insideDont ? Int(match.1!)! * Int(match.2!)! : nil
        }
        insideDont = match.0.starts(with: "don't(") // True if “don't”; false if “do”
        return nil
    }.reduce(0, +)
    print(sum)
}
