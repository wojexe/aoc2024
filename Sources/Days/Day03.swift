import ArgumentParser

final class Day03: Solution {
    @Flag() var parts: [Part] = []
    @Flag(name: .shortAndLong) var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day03",
        abstract: "Solve third Advent of Code challange from 2024"
    )

    func partOne(_ input: String) -> Int {
        let parsed = parse(input)

        let globalRegex = /mul\(\d+,\d+\)/
        let localRegex = /mul\((\d+),(\d+)\)/

        return parsed
            .matches(of: globalRegex)
            .map { $0.output }
            .map { $0.matches(of: localRegex) }
            .flatMap { $0.map { (Int($0.output.1)!, Int($0.output.2)!) } }
            .reduce(into: 0) { acc, tuple in acc += tuple.0 * tuple.1 }
    }

    func partTwo(_ input: String) -> Int {
        let parsed = parse(input)

        let globalRegex = /(?:mul\(\d+,\d+\))|(?:do\(\))|(?:don't\(\))/

        var shouldSkip = false

        return parsed
            .matches(of: globalRegex)
            .map { Command($0.output) }
            .reduce(into: 0) { acc, instruction in
                switch instruction {
                case .do:
                    shouldSkip = false
                case .dont:
                    shouldSkip = true
                case let .mul(a, b) where shouldSkip == false:
                    acc += a * b
                case .mul:
                    break
                }
            }
    }

    private func parse(_ input: String) -> String {
        input
            .split { $0.isNewline }
            .joined(separator: "")
    }
}

private enum Command {
    case mul(Int, Int)
    case `do`
    case dont

    init(_ s: Substring) {
        if s.starts(with: "don't") {
            self = .dont
        } else if s.starts(with: "do") {
            self = .do
        } else {
            self = s.matches(of: /mul\((\d+),(\d+)\)/)
                .map { $0.output }
                .map { Command.mul(Int($0.1)!, Int($0.2)!) }
                .first!
        }
    }
}
