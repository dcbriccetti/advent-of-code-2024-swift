func day3() throws {
    let data = try String(contentsOfFile: path + "/3-test.txt", encoding: .utf8)
    let sum: Int = data.matches(of: /mul\((\d+)\,(\d+)\)/)
        .map { Int($0.1)! * Int($0.2)! }
        .reduce(0, +)
    print("Sum of products: \(sum)")
}
