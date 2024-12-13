import Foundation

func day7(for part: Part) async throws {
    let problems: [(Int, [Int])] = try String(contentsOfFile: path + "/7.txt", encoding: .utf8)
        .split(separator: "\n")
        .map { line in
            let parts = line.split(separator: ": ")
            let answer = Int(parts[0])!
            let operands = parts[1].split(separator: " ")
                .map { operand in
                    Int(operand)!
                }
            return (answer, operands)
        }

    let operators = [
        Operator(name: "+", fn: add),
        Operator(name: "*", fn: multiply),
        part == .part2 ? Operator(name: "||", fn: concatenate) : nil,
    ].compactMap { $0 }

    let totalCalibrationResult = await withTaskGroup(of: Int.self) { group in
        for (correctResult, operands) in problems {
            group.addTask {
                print()
                print(correctResult, operands)

                let numOperators = operands.count - 1
                let combos = await generateCombinations(operators, length: numOperators)

                for ops in combos {
                    var result = operands[0]
                    let operandsPairs = zip(ops, operands.dropFirst())
                    for (op, operand) in operandsPairs {
                        result = op.fn(result, operand)
                    }
                    if result == correctResult {
                        print("\(result) 😀")
                        return correctResult
                    }
                }

                return 0
            }
        }

        return await group.reduce(0, +)
    }

    print("Calibration result: \(totalCalibrationResult)")
}

struct Operator: CustomStringConvertible {
    let name: String
    let fn: (Int, Int) -> Int

    var description: String {
        name
    }
}

func add(num1: Int, num2: Int) -> Int {
    num1 + num2
}

func multiply(num1: Int, num2: Int) -> Int {
    num1 * num2
}

func concatenate(num1: Int, num2: Int) -> Int {
    Int(String(num1) + String(num2))!
}

actor CombinationCache {
    private var cache: [Int: [[Operator]]] = [:]

    func getCombinations(_ operators: [Operator], length: Int) async -> [[Operator]] {
        if let cachedResult = cache[length] {
            return cachedResult
        }

        guard length > 0 else { return [[]] }

        let result = await generateCombinations(operators, length: length - 1)
            .flatMap { combination in
                operators.map { op in
                    combination + [op]
                }
            }

        cache[length] = result
        return result
    }
}

let combinationCache = CombinationCache()

func generateCombinations(_ operators: [Operator], length: Int) async -> [[Operator]] {
    return await combinationCache.getCombinations(operators, length: length)
}
