import ArgumentParser
import Foundation

protocol Solution: NameDescribable, ParsableCommand {
    var parts: [Part] { get }
    var example: Bool { get }
    var inputs_prefix: String { get }

    associatedtype T
    func partOne(_ input: String) -> T
    func partTwo(_ input: String) -> T

    func run() throws
}

extension Solution {
    var inputs_prefix: String { "Inputs/\(typeName)" }

    func run() throws {
        execute(parts)
    }

    func execute(_ parts: [Part]) {
        var results: [Any?]

        results = switch parts {
        case _ where parts.isEmpty || parts.contains(allOf: [.first, .second]):
            [partOne(loadInput(part: .first)), partTwo(loadInput(part: .second))]
        case [.first]:
            [partOne(loadInput(part: .first)), nil]
        case [.second]:
            [nil, partTwo(loadInput(part: .second))]
        default:
            fatalError("[\(String(describing: self))] Unexpected contents: \(parts)")
        }

        printResults(results)
    }

    func loadInput(part: Part) -> String {
        let fileName = example ? "example" : "puzzle"

        let fileManager = FileManager.default
        var pwd = URL(string: fileManager.currentDirectoryPath)!
        pwd.append(path: inputs_prefix)

        do {
            return try String(
                contentsOfFile: String(describing: pwd.appending(path: "\(fileName).txt")),
                encoding: .utf8
            )
        } catch {
            return try! String(
                contentsOfFile: String(describing: pwd.appending(path: "\(fileName)\(part).txt")),
                encoding: .utf8
            )
        }
    }

    private func printResults(_ results: [Any?]) {
        for (part, result) in results.enumerated() {
            guard result != nil else { continue }

            print("[\(typeName) - part \(part)] \(result!)")
        }
    }
}
