import XCTest
@testable import CodeChallengeMoviewDB

class RemoteMovieDetailLoaderTests: XCTestCase {
    
    private let STATUS_OK = 200
    
    func test_doesNotRequestDataFromURL() {
        let (_, clientSpy) = makeSut()
        
        XCTAssertTrue(clientSpy.requestedURLs.isEmpty)
    }
    
    func test_loadRequestDataFromURL() {
        let url = URL(string: "http://any-url.com")!
        let (sut, clientSpy) = makeSut(url: url)
        
        sut.load(url: url) { _ in }
        
        XCTAssertEqual(clientSpy.requestedURLs, [url])
    }
    
    func test_loadRequestDataFromURLTwice() {
        let url = URL(string: "http://any-url.com")!
        let (sut, clientSpy) = makeSut(url: url)
        
        sut.load(url: url) { _ in }
        sut.load(url: url) { _ in }
        
        XCTAssertEqual(clientSpy.requestedURLs, [url, url])
    }
    
    func test_load_returnsErrorOnClientError() {
        let (sut, clientSpy) = makeSut()
        
        expect(sut, toCompleteWith: .failure(RemoteError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            clientSpy.complete(with: clientError)
        }
    }
    
    func test_load_returnsInvalidDataOnNon200HTTPStatusCode() {
        let (sut, clientSpy) = makeSut()
        
        let invalidStatusCodesSample = [500, 401, 404, 201]
        
        invalidStatusCodesSample.enumerated().forEach { index, statusCode in
            expect(sut, toCompleteWith: .failure(RemoteError.invalidData)) {
                clientSpy.complete(with: Data(), andStatusCode: statusCode, atIndex: index)
            }
        }
    }
    
    func test_load_returnsErronOnInvalidDataOn200HTTPStatusCode() {
        let (sut, clientSpy) = makeSut()
        
        expect(sut, toCompleteWith: .failure(RemoteError.invalidData)) {
            clientSpy.complete(with: Data("invalid data".utf8), andStatusCode: STATUS_OK)
        }
    }
    
    func test_load_returnsItemsOn200HTTPResponseWithJSONItems() {
        let (sut, clientSpy) = makeSut()
        let movieDetail = MovieDetailHelper.makeMovieDetail()
        
        expect(sut, toCompleteWith: .success(movieDetail)) {
            let jsonData = JSONHelper.loadJsonData(for: self, andResourceName: "movieDetailData")
            clientSpy.complete(with: jsonData, andStatusCode: STATUS_OK)
        }
    }
    
    func test_assertThereIsNoCallAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        var sut: RemoteMovieDetailLoader? = RemoteMovieDetailLoader(client: client)
        var results = [RemoteMovieDetailLoader.Result]()
        
        sut?.load(url: url) { result in
            results.append(result)
        }
        sut = nil
        client.complete(with: Data("invalid data".utf8), andStatusCode: STATUS_OK)
        
        XCTAssertTrue(results.isEmpty)
    }
    
    private func expect(_ sut: RemoteMovieDetailLoader,
                toCompleteWith expectedResult: MovieDetailLoader.Result,
                when completion: () -> Void) {
        let expectation = expectation(description: "Wait for load")
        let url = URL(string: "http://any-url.com")!
        sut.load(url: url) { result in
            switch (result, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem)
            case let (.failure(receivedError as RemoteError),
                      .failure(expectedError as RemoteError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        completion()
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (RemoteMovieDetailLoader, HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RemoteMovieDetailLoader(client: clientSpy)
        validateMemoryLeak(sut)
        validateMemoryLeak(clientSpy)
        
        return (sut, clientSpy)
    }
    
    private func loadJsonData() -> Data {
        let url = Bundle(for: type(of: self)).url(forResource: "popularMovieData", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        return jsonData
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            requests.map { $0.url }
        }
        
        var requests = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requests.append((url, completion))
        }
        
        func complete(with error: Error, atIndex index: Int = 0) {
            let request = requests[index]
            request.completion(.failure(error))
        }
        
        func complete(with data: Data, andStatusCode statusCode: Int, atIndex index: Int = 0) {
            let request = requests[index]
            let httpURLResponse = HTTPURLResponse(url: request.url,
                                                  statusCode: statusCode,
                                                  httpVersion: nil,
                                                  headerFields: nil)!
            
            request.completion(.success((data, httpURLResponse)))
        }
    }
}

