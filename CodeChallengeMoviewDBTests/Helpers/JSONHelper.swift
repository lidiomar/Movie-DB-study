import Foundation

class JSONHelper {
    static func loadJsonData<T: AnyObject>(for instanceType: T, andResourceName resource: String) -> Data {
        let url = Bundle(for: type(of: instanceType)).url(forResource: resource, withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        return jsonData
    }

}
