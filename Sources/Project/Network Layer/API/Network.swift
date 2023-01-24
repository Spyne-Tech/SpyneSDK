import Foundation
import Moya
import Alamofire

private class CustomServerTrustPoliceManager: ServerTrustManager {
    
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        return DisabledTrustEvaluator()
    }

    init() {
        super.init(evaluators: [:])
    }
    
    override init(allHostsMustBeEvaluated: Bool = true, evaluators: [String : ServerTrustEvaluating]) {
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated, evaluators: evaluators)
    }
}


struct Network {
    
    
    typealias DecodingData<T> = (type: T.Type, decoder: JSONDecoder)
    
    private static var lastErrorThrowTime = Date(timeIntervalSince1970: 0)
    
    private static var provider: MoyaProvider<APIManager> {
        let configuration = URLSessionConfiguration.default
         configuration.httpMaximumConnectionsPerHost = 12
        let sessionManager = Alamofire.Session(configuration: configuration, serverTrustManager: CustomServerTrustPoliceManager())
        let plugIns = VerbosePlugin()
        let provider = MoyaProvider<APIManager>(session: sessionManager,plugins: [plugIns])
    
        return provider
    }
    
    // swiftlint:disable function_parameter_count
    @discardableResult
    static func request<T, V>(
        _ target: APIManager,
        decodeType type: T.Type,
        errorDecodeType errorType: V.Type,
        decoder: JSONDecoder = JSONDecoder(),
        dispatchQueue: DispatchQueue? = nil,
        success successCallback: @escaping (_ data: T) -> Void,
        error errorCallback: @escaping (_ statusCode: HTTPStatusCode, _ data: V?, _ message: String?) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void,
        completion completionCallback: @escaping () -> Void) -> Cancellable where T: Decodable, V: Decodable {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601

        let cancellableRequest = provider.request(target) { result in
            completionCallback()
            switch result {
            case let .success(response):
                
                let statusCode = HTTPStatusCode(rawValue: response.statusCode) ?? HTTPStatusCode.ok
                
                print(statusCode)
                
                if statusCode == .unauthorized{
                
                   // AppDelegate.navToLogin()
                    
                }else if !statusCode.isSuccess {

                    do {
                        let result = try decoder.decode(CommonMessageRootClass.self, from: response.data)
                        if result.status == 401{
//                            AppDelegate.navToLogin()
                        }
                    }
                    catch {
                        _ = try? response.mapString()
                        //print(string)
                        //errorCallback(statusCode, nil, message)
                    }
                    do {
                        let result = try decoder.decode(V.self, from: response.data)
                        errorCallback(statusCode, result, nil)
                    }
                    catch {
                        let string = try? response.mapString()
                        let message = string ?? "no string error"
                        errorCallback(statusCode, nil, message)
                    }
                }
                else {
                    // If Not Logged in then redirect to Login
                    do {
                        let result = try decoder.decode(CommonMessageRootClass.self, from: response.data)
                        if result.status == 401{
//                            AppDelegate.navToLogin()
                        }
                    }
                    catch {
                        _ = try? response.mapString()
                        //print(string)
                        //errorCallback(statusCode, nil, message)
                    }
                    do {
                        let result = try decoder.decode(T.self, from: response.data)
                        successCallback(result)
                    }
                    catch let e {
                        errorCallback(statusCode, nil, e.localizedDescription)
                    }
                }
            case let .failure(error):
                if Date().timeIntervalSince(lastErrorThrowTime) >= 15 {
                    lastErrorThrowTime = Date()
                }
                failureCallback(error)
            }
        }
        return cancellableRequest
    }
    
    
    
}
