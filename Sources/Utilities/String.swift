extension String {
    subscript(_ offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
