import Foundation

final class OpenBetaService {

    private let client = GraphQLClient()

    func searchAreas(name: String) async throws -> [Area] {

        let query = """
        query($name: String!) {
          areas(filter: { area_name: { match: $name } }) {
            area_name
            uuid
            metadata {
              lat
              lng
            }
          }
        }
        """

        struct Response: Decodable {
            struct DataContainer: Decodable {
                let areas: [Area]
            }
            let data: DataContainer
        }

        let response: Response = try await client.fetch(
            query: query,
            variables: ["name": name]
        )

        return response.data.areas
    }

    func fetchBoulders(areaId: String) async throws -> [Boulder] {

        let query = """
        query($id: ID!) {
          area(uuid: $id) {
            climbs {
              uuid
              name
              grades {
                vscale
              }
              type
            }
          }
        }
        """

        struct Response: Decodable {
            struct DataContainer: Decodable {
                struct AreaContainer: Decodable {
                    let climbs: [Boulder]
                }
                let area: AreaContainer
            }
            let data: DataContainer
        }

        let response: Response = try await client.fetch(
            query: query,
            variables: ["id": areaId]
        )

        return response.data.area.climbs
    }
}
