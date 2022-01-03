import Foundation

enum RemoteError: Error {
    case invalidData
    case connectivity
}

class URLSessionHTTPClient: HTTPClient {
    private var session: URLSession
    private struct UnepextedValuesRepresentation: Error {}
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(UnepextedValuesRepresentation()))
                }
            }
        }.resume()
    }
    
}
