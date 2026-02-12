import Foundation

final class GraphQLClient {

    private let endpoint = URL(string: "https://api.openbeta.io/graphql")!

    func fetch<T: Decodable>(
        query: String,
        variables: [String: Any]
    ) async throws -> T {

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "query": query,
            "variables": variables
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
