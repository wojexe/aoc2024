import ArgumentParser

final class Day02: Solution {
    @Flag() var parts: [Part] = []
    @Flag(name: .shortAndLong) var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day02",
        abstract: "Solve second Advent of Code challange from 2024"
    )

    static let AT_LEAST = 1
    static let AT_MOST = 3

    func partOne(_ input: String) -> Int {
        parse(input)
            .reduce(into: 0) { acc, report in
                if isMonotonic(report, comparison: <) ||
                    isMonotonic(report, comparison: >) { acc += 1 }
            }
    }

    func partTwo(_ input: String) -> Int {
        parse(input)
            .reduce(into: 0) { acc, report in
                acc +=
                    isMonotonic(report, comparison: <) ||
                    isMonotonic(report, comparison: >) ||
                    report.indices.reduce(into: false) { acc, i in
                        var dampened = report
                        dampened.remove(at: i)

                        acc = acc ||
                            isMonotonic(dampened, comparison: <) ||
                            isMonotonic(dampened, comparison: >)
                    }
                    ? 1 : 0
            }
    }

    private func parse(_ input: String) -> [[Int]] {
        input
            .split { $0.isNewline }
            .map { $0.split { $0.isWhitespace }.map { Int($0)! } }
    }

    func isMonotonic(_ seq: any Sequence<Int>, tolerance: Int = 0, comparison: (Int, Int) -> Bool) -> Bool {
        var tolerance = tolerance
        var prev: Int? = nil

        for elem in seq {
            guard prev != nil else { prev = elem; continue }

            guard comparison(prev!, elem)
                && abs(elem - prev!) >= Self.AT_LEAST
                && abs(elem - prev!) <= Self.AT_MOST
            else {
                if tolerance > 0 { tolerance -= 1; continue }
                else { return false }
            }

            prev = elem
        }

        return true
    }
}
