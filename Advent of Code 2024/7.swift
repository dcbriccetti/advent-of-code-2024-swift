func day7(for part: Part) throws {
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

    var totalCalibrationResult = 0

    for (correctResult, operands) in problems {
        print()
        print(correctResult, operands)
        let numOperators = operands.count - 1
        for ops: [Operator] in generateCombinations(operators, length: numOperators) {
            var result = operands[0]
            let operandsPairs = zip(ops, operands.dropFirst())
            for (op, operand) in operandsPairs {
                result = op.fn(result, operand)
            }
            if result == correctResult {
                print("\(result) 😀")
                totalCalibrationResult += correctResult
                break
            }
        }
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

var combinationCache: [Int: [[Operator]]] = [:]

func generateCombinations(_ operators: [Operator], length: Int) -> [[Operator]] {
    if let cachedResult = combinationCache[length] {
        return cachedResult
    }
    guard length > 0 else { return [[]] }
    let result = generateCombinations(operators, length: length - 1)
        .flatMap { combination in
            operators.map { op in
                combination + [op]
            }
        }
    combinationCache[length] = result
    return result
}
