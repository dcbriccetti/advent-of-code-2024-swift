func day11() throws {
    let input = "125 17"
    var stoneCounts = [Int : Int]()
    input
        .split(separator: " ")
        .forEach { numString in
            let stone = Int(numString)!
            stoneCounts[stone, default: 0] += 1
        }

    for i in 1...75 {
        stoneCounts = blink(stoneCounts)
        print(i, stoneCounts.count, stoneCounts.values.reduce(0, +)/*, stoneCounts*/)
    }

    func blink(_ stoneCounts: [Int : Int]) -> [Int : Int] {
        var newStoneCounts = [Int : Int]()
        for (stone, count) in stoneCounts {
            let stoneDigits = String(stone)
            let numDigits = stoneDigits.count
            if stone == 0 {
                newStoneCounts[1, default: 0] += count
            } else if numDigits % 2 == 0 {
                let left  = Int(stoneDigits.prefix(numDigits / 2))!
                let right = Int(stoneDigits.suffix(numDigits / 2))!
                newStoneCounts[left, default: 0] += count
                newStoneCounts[right, default: 0] += count
            } else {
                newStoneCounts[stone * 2024, default: 0] += count
            }
        }
        return newStoneCounts
    }
}

