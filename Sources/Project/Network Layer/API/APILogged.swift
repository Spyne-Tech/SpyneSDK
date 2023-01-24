//
//  APILogged.swift

import Foundation
import Moya
import Alamofire
//import Result

struct VerbosePlugin: PluginType {
    
    
    fileprivate let loggerId = "Logger"
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    fileprivate let requestDataFormatter: ((Data) -> (String))?
    fileprivate let responseDataFormatter: ((Data) -> (Data))?

    /// A Boolean value determing whether response body data should be logged.
    public let isVerbose: Bool
    public let cURL: Bool

    /// Initializes a NetworkLoggerPlugin.
    public init(verbose: Bool = false, cURL: Bool = false, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = nil) {
        self.cURL = cURL
        self.isVerbose = verbose
        self.output = output ?? VerbosePlugin.reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        if let request = request as? CustomDebugStringConvertible, cURL {
            output(separator, terminator, request.debugDescription)
            return
        }
        outputItems(logNetworkRequest(request.request as URLRequest?))
    }
    
    func didReceive(_ result: Swift.Result<Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            outputItems(logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
    }

    fileprivate func outputItems(_ items: [String]) {
        
            print("✅======================= API Logged =======================✅")
        
            items.forEach { output(separator, terminator, $0) }
        
            print("✅======================= API Logged =======================✅")
    }
    
   
}


private extension VerbosePlugin {

    func format(identifier: String, message: String) -> String {
        return "\(identifier) => \(message)"
    }

    func logNetworkRequest(_ request: URLRequest?) -> [String] {

        var output = [String]()

        output += [format(identifier: "URL", message: request?.description ?? "(invalid request)")]

        if let httpMethod = request?.httpMethod {
            output += [format(identifier: "METHOD", message: httpMethod)]
        }
        
        if let headers = request?.allHTTPHeaderFields {
            output += [format(identifier: "HEADERS", message: headers.description)]
        }

        if let bodyStream = request?.httpBodyStream {
            output += [format(identifier: "BODY", message: bodyStream.description)]
        }

       

        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8) {
            output += [format(identifier: "BODY", message: stringOutput)]
        }

        return output
    }

    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
        

        var output = [String]()


        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8) {
            output += [stringData]
        }

        return output
    }
}

fileprivate extension VerbosePlugin {
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}
