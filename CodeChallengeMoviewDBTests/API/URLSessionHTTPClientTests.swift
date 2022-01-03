import Foundation
import XCTest
@testable import CodeChallengeMoviewDB

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptRequests()
    }
    
    func test_performGETRequestWithURL() {
        let sut = makeSUT()
        let url = anyURL()
        let sutExpectation = expectation(description: "Wait HTTPClient GET")
        let urlProtocolStubExpectation = expectation(description: "Wait URLProtocolStub observer be called.")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            urlProtocolStubExpectation.fulfill()
        }
        
        sut.get(from: url) { _ in
            sutExpectation.fulfill()
        }
        
        wait(for: [sutExpectation, urlProtocolStubExpectation], timeout: 1.0)
    }
    
    func test_performRequestWithURL_failsOnRequestError() {
        let expectedError = NSError(domain: "domain", code: 0)
        let receivedError = resultError(data: nil, response: nil, error: expectedError) as NSError
        
        XCTAssertEqual(expectedError.code, receivedError.code)
        XCTAssertEqual(expectedError.domain, receivedError.domain)
    }
    
    func test_getFromURL_succedsOnHTTPURLResponseWithData() {
        let sut = makeSUT()
        let url = anyURL()
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let exp = expectation(description: "Wait HTTPClient GET")
        URLProtocolStub.stub(data: data, response: response, error: nil)
        
        sut.get(from: url) { result in
            switch result {
            case let .success((receivedData, receivedResponse)):
                XCTAssertEqual(receivedData, data)
                XCTAssertEqual(receivedResponse.url, response.url)
                XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
            default:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultError(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultError(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultError(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultError(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultError(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultError(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    // - MARK: Helpers
    
    private func makeSUT() -> HTTPClient {
        let sut = URLSessionHTTPClient()
        validateMemoryLeak(sut)
        return sut
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func resultError(data: Data?, response: URLResponse?, error: NSError?) -> Error {
        let url = anyURL()
        let sut = makeSUT()
        let exp = expectation(description: "Wait HTTPClient GET")
        var receivedError: Error!
        
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected error, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private class URLProtocolStub: URLProtocol {
        static var requestObserver: ((URLRequest) -> Void)?
        private static var stub: Stub?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: NSError?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: NSError?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            requestObserver = nil
        }
        
        static func observeRequest(request: ((URLRequest) -> Void)?) {
            URLProtocolStub.requestObserver = request
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                requestObserver(request)
                return
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
    
}
