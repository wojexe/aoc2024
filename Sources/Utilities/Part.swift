import ArgumentParser

enum Part: EnumerableFlag, Comparable, CustomStringConvertible {
    static func name(for value: Self) -> NameSpecification {
        switch value {
        case .first:
            return [.short, .customLong("first")]
        case .second:
            return [.short, .customLong("second")]
        }
    }

    var description: String {
        switch self {
        case .first:
            return "1"
        case .second:
            return "2"
        }
    }

    case first, second
}
