public extension Sequence where Element: Equatable {
    func contains(anyOf sequence: [Element]) -> Bool {
        return self.filter { sequence.contains($0) }.count > 0
    }

    func contains(allOf sequence: [Element]) -> Bool {
        return self.filter { sequence.contains($0) }.count == sequence.count
    }
}
