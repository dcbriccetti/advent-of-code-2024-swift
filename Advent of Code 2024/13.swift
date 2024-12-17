import Foundation

func day13(for part: Part) {
    struct Machine {
        let buttonA: Vector
        let buttonB: Vector
        let prize: Vector

        static func parse(_ textData: String) -> Machine {
            func extractIntegers(from input: String) -> [Int] {
                let regex = try! NSRegularExpression(pattern: #"(\d+)"#)
                return regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
                    .flatMap { match in
                        (1..<match.numberOfRanges).compactMap { i in
                            return Int(input[Range(match.range(at: i), in: input)!])
                        }
                }
            }

            let nums = extractIntegers(from: textData)
            return Machine(
                buttonA: Vector(y: nums[1], x: nums[0]),
                buttonB: Vector(y: nums[3], x: nums[2]),
                prize:   Vector(y: nums[5], x: nums[4])
            )
        }
    }

    let machines = try! String(contentsOfFile: path + "/13-test.txt", encoding: .utf8)
        .split(separator: "\n\n")
        .map { Machine.parse(String($0)) }
    print(machines)
}
