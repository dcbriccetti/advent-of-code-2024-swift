import Foundation

func day17(for part: Part) {
    func getInput() -> (regVals: [Int], opcodes: [Int]) {
        let parts = try! String(contentsOfFile: path + "/17.txt", encoding: .utf8)
            .split(separator: "\n\n")
        let regVals = parts[0]
            .split(separator: "\n")
            .map { line in
                Int(line.split(separator: ": ")[1])!
            }
        let opCodes = parts[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ": ")[1]
            .split(separator: ",")
            .map { Int($0)! }
        return (regVals, opCodes)
    }

    func comboVal(_ operand: Int) -> Int {
        var result: Int
        switch operand {
        case 0...3, 7:
            result = operand
        case 4:
            result = regA
        case 5:
            result = regB
        case 6:
            result = regC
        default:
            fatalError()
        }
        return result
    }

    enum OpCode: Int {
        case adv, bxl, bst, jnz, bxc, out, bdv, cdv
    }

    let (regVals, opCodes) = getInput()
    var regA = regVals[0]
    var regB = regVals[1]
    var regC = regVals[2]
    var output = [Int]()
    var ip = 0

    while ip < opCodes.count {
        var jumped = false
        let opCode = OpCode(rawValue: opCodes[ip])
        let literalOperand: Int = opCodes[ip + 1]
        let operand = comboVal(literalOperand)

        func div() -> Int {
            regA / Int(pow(Double(2), Double(operand)))
        }

        print("ip: \(ip), opCode: \(opCode!.rawValue), operand: \(operand), regA: \(regA), regB: \(regB), regC: \(regC)")
        switch opCode {
        case .adv:
            regA = div()
        case .bxl:
            regB ^= literalOperand
        case .bst:
            regB = operand % 8
        case .jnz:
            if regA != 0 {
                ip = literalOperand
                jumped = true
            }
        case .bxc:
            regB ^= regC
        case .out:
            output.append(operand % 8)
        case .bdv:
            regB = div()
        case .cdv:
            regC = div()
        default:
            fatalError()
        }
        if !jumped {
            ip += 2
        }
    }
    print(output.map { String($0) }.joined(separator: ","))
    print("regA: \(regA), regB: \(regB), regC: \(regC)")
}
