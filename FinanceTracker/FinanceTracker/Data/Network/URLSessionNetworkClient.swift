import Foundation

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = URLSessionNetworkClient.makeSession()) {
        self.session = session
    }

    func get<T: Decodable>(_ url: URL, decoder: JSONDecoder) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.httpStatus(http.statusCode)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding
            }
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.transport
        }
    }

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        return URLSession(configuration: configuration)
    }
}
