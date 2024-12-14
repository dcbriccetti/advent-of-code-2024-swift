func day11(for part: Part) throws {
//    let input = "125 17"
    let input = "965842 9159 3372473 311 0 6 86213 48"
    var stones = input
        .split(separator: " ")
        .map { Int($0)! }

    for i in 1...25 {
        print(i, stones.count)
        stones = blink(stones)
    }
    print(stones.count)

    func blink(_ stones: [Int]) -> [Int] {
        var newStones = [Int]()
        for stone in stones {
            let stoneDigits = String(stone)
            let numDigits = stoneDigits.count
            if stone == 0 {
                newStones.append(1)
            } else if numDigits % 2 == 0 {
                newStones.append(Int(stoneDigits.prefix(numDigits / 2))!)
                newStones.append(Int(stoneDigits.suffix(numDigits / 2))!)
            } else {
                newStones.append(stone * 2024)
            }
        }
        return newStones
    }
}

