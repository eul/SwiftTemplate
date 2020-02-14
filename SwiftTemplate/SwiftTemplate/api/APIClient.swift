//
//  APIClient.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Network

protocol ClientProtocol {
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

final class APIClient: ClientProtocol {
    
    private let manager: Alamofire.SessionManager
    private let monitor = NWPathMonitor()

    public static let baseURL = URL(string: Config.apiUrl)!
    public static let SERVER_IMAGES_URL = APIClient.baseURL.absoluteString + "uploads/"
    public  let identityKey             = "Authorization"
    public var identityToken :String?
    
    private let queue             = DispatchQueue(label: "STNetwork")
    private var internetAvailable = true

    init(accessToken: String?) {
        
        let configuration = URLSessionConfiguration.default
        
        self.manager = Alamofire.SessionManager(configuration: configuration)
        //  self.manager.retrier = OAuth2Retrier()
        
        self.identityToken = accessToken

        setupNetworkMonitor()
    }

    deinit {
        monitor.cancel()
    }

    private func setupNetworkMonitor() {

        monitor.pathUpdateHandler = {[weak self] path in

            self?.internetAvailable = (path.status == .satisfied)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")

        monitor.start(queue: queue)
    }
    
    public func clearCookies() {
        
        identityToken = nil
        
        let cstorage = HTTPCookieStorage.shared
        
        if let cookies = cstorage.cookies(for: APIClient.baseURL) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
    }
    
    public func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        if let identityCookiesValue_ = identityToken {
            headers[identityKey] = "Bearer \(identityCookiesValue_)"
        }
        
        return headers
    }
    
    public func fillHeadersFor(request: inout URLRequest) {
        
        for (key, value) in headers() {
            
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        
        return Single<Response>.create {[unowned self] observer in

            if !self.internetAvailable {

                let noInternetError = NoInternetError()
                ErrorHandler().handle(error: noInternetError, description: nil)

                observer(.error(noInternetError))

                return Disposables.create()
            }
            
            var url = endpoint.isUnicPath
                      ? URL(string: endpoint.path)!
                      : self.url(path: endpoint.path)

            if let queryParams = endpoint.queryItems {

                url = URL(string:url.appendingQueryItems(queryParams))!
                
                print(url.absoluteString)
            }
            
            let request = self.manager.request( url,
                                        method: httpMethod(from: endpoint.method),
                                    parameters: endpoint.parameters,
                                      encoding: endpoint.paramsEncoding,
                                       headers: self.headers())

            request.validate().responseData(queue: self.queue) { response in
                
                if let body = response.request?.httpBody {
                    print(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")
                }
 
                let result = response.result.flatMap(endpoint.decode)
                
                switch result {
                case let .success(val): observer(.success(val))
                case let .failure(err):
                    
                    let tomatoError = ErrorHandler().wrap(error: err, response: response)
                    
                    ErrorHandler().handle(error: tomatoError, description: nil)
                    
                    observer(.error(tomatoError))
                }
            }

            return Disposables.create {
                
                request.cancel()
            }
        }
    }
    
    private func url(path: Path) -> URL {
        
        return APIClient.baseURL.appendingPathComponent(path)
    }
}

public func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
    
    switch method {
    case .get:    return .get
    case .post:   return .post
    case .put:    return .put
    case .patch:  return .patch
    case .delete: return .delete
    }
}


public class OAuth2Retrier: Alamofire.RequestRetrier {
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if (error as? AFError)?.responseCode == 401 {
            
            // TODO: implement your Auth2 refresh flow
            // See https://github.com/Alamofire/Alamofire#adapting-and-retrying-requests
        }
        
        completion(false, 0)
    }
}

private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}

/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
public struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}

