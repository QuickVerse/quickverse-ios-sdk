struct QuickVerseLocalization: Decodable {
    let key: String
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case key
        case value = "target_text"
    }
}
