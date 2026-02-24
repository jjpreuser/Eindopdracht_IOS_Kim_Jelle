struct CoverageJSON: Codable {
    let type: String
    let domain: Domain?
    let parameters: [String: Parameter]?
}

struct Domain: Codable {
    let type: String
    let axes: [String: Axis]
}

struct Axis: Codable {
    let values: [Double]?
}

struct Parameter: Codable {
    let type: String
    let values: [Double]?
}
