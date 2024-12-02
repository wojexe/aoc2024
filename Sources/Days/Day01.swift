import ArgumentParser

final class Day01: Solution {
    @Flag() var parts: [Part] = []
    @Flag() var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day01",
        abstract: "Solve first Advent of Code challange from 2024"
    )

    func partOne(_ input: String) -> Int {
        var (left, right) = parse(input)

        left.sort()
        right.sort()

        return zip(left, right).reduce(into: 0) { $0 += abs($1.0 - $1.1) }
    }

    func partTwo(_ input: String) -> Int {
        let (left, right) = parse(input)

        var occurances: [Int: Int] = [:]
        for ID in right {
            occurances[ID, default: 0] += 1
        }

        return left.reduce(into: 0) { $0 += $1 * occurances[$1, default: 0] }
    }

    private func parse(_ input: String) -> ([Int], [Int]) {
        intoLists(input.split { $0.isWhitespace }.map { Int($0)! })
    }

    private func intoLists(_ list: [Int]) -> ([Int], [Int]) {
        let left = stride(from: list.startIndex, to: list.endIndex, by: 2).map { list[$0] }
        let right = stride(from: list.startIndex + 1, to: list.endIndex, by: 2).map { list[$0] }

        return (left, right)
    }
}
