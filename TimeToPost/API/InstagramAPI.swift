import Foundation
import Moya

// MARK: API Setup

struct Constants {
    static let baseURL = "https://insights-for-instagram.herokuapp.com/api/" //From Github/admango
}

let InstagramProvider = MoyaProvider<Instagram>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseFormatter)])

// serialize data to json
private func JSONResponseFormatter(_ data: Data) -> Data {
    do {
        let JSONData = try JSONSerialization.jsonObject(with: data)
        let niceData = try JSONSerialization.data(withJSONObject: JSONData, options: .prettyPrinted)
        return niceData
    } catch {
        return data // if data cant be serialized return original data
    }
}




// MARK: Provider support

private extension String {
    var urlEscaped: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

public enum Instagram {
    case userMedia(String)
}

extension Instagram: TargetType {
    public var baseURL: URL {return URL(string: Constants.baseURL)!}
    public var path: String {
        switch self {
        case .userMedia(let name):
            guard let name = name.urlEscaped else { return "" }
            return "users/\(name)/media"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    
    public var sampleData: Data{
        return Data()
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

private func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

func stubbedResponse(_ filename: String) -> Data? {
    @objc class TestClass: NSObject {}
    let bundle = Bundle(for: TestClass.self)
    guard let path = bundle.path(forResource: filename, ofType: "json") else { return nil }
    return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    
}

// MARK: Response Handler

extension Moya.Response {
    func mapNSArray() throws -> [String: Any] {
        let any = try self.mapJSON()
        guard let array = any as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}



