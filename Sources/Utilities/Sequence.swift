public extension Sequence where Element: Comparable {
    func contains(anyOf sequence: [Element]) -> Bool {
        filter { sequence.contains($0) }.count > 0
    }

    func contains(allOf sequence: [Element]) -> Bool {
        filter { sequence.contains($0) }.count == sequence.count
    }
}
