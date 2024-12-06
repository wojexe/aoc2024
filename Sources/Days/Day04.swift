import ArgumentParser

final class Day04: Solution {
    @Flag() var parts: [Part] = []
    @Flag(name: .shortAndLong) var example: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "day04",
        abstract: "Solve fourth Advent of Code challange from 2024"
    )

    func partOne(_ input: String) -> Int {
        let lines = parse(input)

        var count = 0
        for (row, line) in lines.enumerated() {
            count += countHorizontal(line)
            count += countVertical(row, lines)
            count += countDiagonal(row, lines)
        }

        return count
    }

    func partTwo(_ input: String) -> Int {
        let lines = parse(input)

        var count = 0
        for (row, _) in lines.enumerated() {
            count += countDiagonal_2(row, lines)
        }

        return count
    }

    private func parse(_ input: String) -> [String] {
        return input
            .split { $0.isWhitespace }
            .map(String.init)
    }

    private func countHorizontal(_ input: any StringProtocol) -> Int {
        var count = 0
        for col in 0 ..< input.count {
            let offset = Substring.Index(utf16Offset: col, in: input)
            let s = input[offset...]

            count += s.starts(with: "XMAS") ? 1 : 0
            count += s.starts(with: "SAMX") ? 1 : 0
        }
        return count
    }

    private func countVertical(_ row: Int, _ lines: [String]) -> Int {
        let line = lines[row]
        var count = 0
        for col in 0 ..< line.count {
            count += checkDown(from: (row, col), lines) ? 1 : 0
        }
        return count
    }

    private func checkDown(from: (Int, Int), _ lines: [String]) -> Bool {
        let (row, col) = from

        guard row + 3 < lines.count else { return false }

        var s = ""
        for i in 0 ... 3 {
            let row = row + i
            let col = String.Index(utf16Offset: col, in: lines[row])
            s += "\(lines[row][col])"
        }

        return s == "XMAS" || s == "SAMX"
    }

    private func countDiagonal(_ row: Int, _ lines: [String]) -> Int {
        let line = lines[row]
        var count = 0
        for col in 0 ..< line.count {
            // .  x
            // x  .
            count += checkUpRight(from: (row, col), lines) ? 1 : 0

            // x  .
            // .  x
            count += checkUpLeft(from: (row, col), lines) ? 1 : 0
        }
        return count
    }

    private func checkUpRight(from: (Int, Int), _ lines: [String]) -> Bool {
        let (row, col) = from

        guard row - 3 >= 0 else { return false }
        guard col + 3 < lines[row].count else { return false }

        var s = ""
        for i in 0 ... 3 {
            let row = row - i
            let col = String.Index(utf16Offset: col + i, in: lines[row])
            s += "\(lines[row][col])"
        }

        return s == "XMAS" || s == "SAMX"
    }

    private func checkUpLeft(from: (Int, Int), _ lines: [String]) -> Bool {
        let (row, col) = from

        guard row - 3 >= 0 else { return false }
        guard col - 3 >= 0 else { return false }

        var s = ""
        for i in 0 ... 3 {
            let row = row - i
            let col = String.Index(utf16Offset: col - i, in: lines[row])
            s += "\(lines[row][col])"
        }

        return s == "XMAS" || s == "SAMX"
    }

    private func countDiagonal_2(_ row: Int, _ lines: [String]) -> Int {
        let line = lines[row]
        var count = 0
        for col in 0 ..< line.count {
            count +=
                checkDownRight(from: (row, col), lines, ["SAM", "MAS"]) &&
                checkDownLeft(from: (row, col + 2), lines, ["SAM", "MAS"])
                ? 1 : 0
        }
        return count
    }

    private func checkDownRight(from: (Int, Int), _ lines: [String], _ search: [String]) -> Bool {
        let (row, col) = from

        guard row + 2 < lines.count else { return false }
        guard col + 2 < lines[row].count else { return false }

        var s = ""
        for i in 0 ... 2 {
            let row = row + i
            let col = String.Index(utf16Offset: col + i, in: lines[row])
            s += "\(lines[row][col])"
        }

        return search.contains(s)
    }

    private func checkDownLeft(from: (Int, Int), _ lines: [String], _ search: [String]) -> Bool {
        let (row, col) = from

        guard
            col < lines[row].count else { return false }

        guard
            row + 2 < lines.count &&
            col - 2 >= 0 else { return false }

        var s = ""
        for i in 0 ... 2 {
            let row = row + i
            let col = String.Index(utf16Offset: col - i, in: lines[row])
            s += "\(lines[row][col])"
        }

        return search.contains(s)
    }
}
