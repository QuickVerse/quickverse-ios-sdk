extension String {
    func lowercasingFirstLetter() -> String {
      return prefix(1).lowercased() + self.dropFirst()
    }
}
