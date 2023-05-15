enum RequestType {
    case localizations
    case reporting
    
    var path: String {
        switch self {
        case .localizations: return "localisation/"
        case .reporting: return "report"
        }
    }
}
