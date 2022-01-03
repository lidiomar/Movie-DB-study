import Foundation

final class ResultHelper {
    private static let statusOK = 200
    
    static func prepareResult<T, U: Decodable>(result: HTTPClient.Result,
                                               completion: @escaping (Result<T, Error>) -> Void,
                                               mapData: @escaping (U) -> T) {
        switch result {
        case let .success((data , httpURLResponse)):
            completion(ResultHelper.convertToModel(data: data,
                                                   statusCode: httpURLResponse.statusCode,
                                                   convertCompletion: mapData))
        case .failure:
            completion(.failure(RemoteError.connectivity))
        }
    }
    
    private static func convertToModel<T, U: Decodable>(data: Data,
                                                        statusCode: Int,
                                                        convertCompletion: (U) -> T) -> (Result<T, Error>) {
        guard statusCode == ResultHelper.statusOK,
                let decodableData = try? JSONDecoder().decode(U.self, from: data) else {
            return .failure(RemoteError.invalidData)
        }
        return .success(convertCompletion(decodableData))
    }
}

