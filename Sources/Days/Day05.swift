import ArgumentParser

final class Day05: Solution {
    @Flag() var parts: [Part] = []
    @Flag(name: .shortAndLong) var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day05",
        abstract: "Solve fifth Advent of Code challange from 2024"
    )

    func partOne(_ input: String) -> Int {
        let (rules, updates) = parse(input)

        return
            updates.reduce(into: 0) { acc, update in
                acc += updateValid(update, rules) ? update[update.count / 2] : 0
            }
    }

    func partTwo(_ input: String) -> Int {
        let (rules, updates) = parse(input)
        let invalidUpdates = updates.filter { updateValid($0, rules) == false }
        let fixedUpdates = invalidUpdates.map { fixUpdate($0, rules) }

        return fixedUpdates.reduce(into: 0) { $0 += $1[$1.count / 2] }
    }

    private func updateValid(_ update: [Int], _ rules: Rules) -> Bool {
        var seen = Set<Int>()

        for item in update {
            guard seen.intersection(rules[item, default: Set()]).count == 0 else {
                return false
            }

            seen.insert(item)
        }

        return true
    }

    private func fixUpdate(_ update: [Int], _ rules: Rules) -> [Int] {
        var fixed: [Int] = [update[0]]

        for item in update[1...] {
            var next = fixed
            for i in fixed.indices + [fixed.count] {
                next = fixed
                next.insert(item, at: i)

                if updateValid(next, rules) { break }
            }
            fixed = next
        }

        return fixed
    }

    typealias Rules = [Int: Set<Int>]

    private func parse(_ input: String) -> (Rules, [[Int]]) {
        let parts = input
            .split(separator: "\n\n")
            .map { $0.split { $0.isWhitespace } }

        return (parseRules(parts[0]), parseUpdates(parts[1]))
    }

    private func parseRules(_ rules: [any StringProtocol]) -> Rules {
        var dict: Rules = [:]

        rules
            .map { $0.split(separator: "|").map { Int($0)! } }
            .forEach { dict[$0[0], default: Set()].insert($0[1]) }

        return dict
    }

    private func parseUpdates(_ updates: [any StringProtocol]) -> [[Int]] {
        updates
            .map { $0.split(separator: ",").map { Int($0)! } }
    }
}
