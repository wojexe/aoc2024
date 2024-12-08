import ArgumentParser

final class Day07: Solution {
    @Flag() var parts: [Part] = []
    @Flag(name: .shortAndLong) var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day07",
        abstract: "Solve seventh Advent of Code challange from 2024"
    )

    func partOne(_ input: String) -> Int {
        let equations = parse(input)
        return equations.reduce(into: 0) { $0 += processEquation($1, [(+), (*)]) }
    }

    func partTwo(_ input: String) -> Int {
        let equations = parse(input)
        return equations.reduce(into: 0) { $0 += processEquation($1, [(+), (*), concatenate]) }
    }

    typealias Equation = (target: Int, numbers: [Int])

    private func processEquation(_ equation: Equation, _ operators: [(Int, Int) -> Int]) -> Int {
        if processEquationRec(into: equation.numbers.first!, equation.target, equation.numbers.dropFirst(), operators) {
            equation.target
        } else {
            0
        }
    }

    private func processEquationRec(into accumulator: Int, _ target: Int, _ numbers: ArraySlice<Int>, _ operators: [(Int, Int) -> Int]) -> Bool {
        guard numbers.count > 0 else {
            if target == accumulator { return true }
            return false
        }

        return operators.reduce(into: false) { result, op in
            if result == true { return }

            result = result ||
                processEquationRec(
                    into: op(accumulator, numbers.first!),
                    target,
                    numbers.dropFirst(),
                    operators
                )
        }
    }

    private func concatenate(_ a: Int, _ b: Int) -> Int { Int("\(a)\(b)")! }

    private func parse(_ input: String) -> [Equation] {
        input
            .split { $0.isNewline }
            .map(parseEquation)
    }

    private func parseEquation(_ line: any StringProtocol) -> Equation {
        let parts = line.split(separator: ": ")
        let target = Int(parts[0])!
        let numbers = parts[1].split { $0.isWhitespace }.map { Int($0)! }
        return (target, numbers)
    }
}
