import ArgumentParser

@main
struct Advent_of_Code_2024: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "aoc2024",
        subcommands: [Day01.self, Day02.self, Day03.self]
    )
}
