//
//  Endpoint.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import Alamofire

public typealias Parameters = [String: Any]
typealias Path = String

public enum Method {
    case get, post, put, patch, delete
}

final class Endpoint<Response> {
    
    let method        : Method
    let path          : Path
    let isUnicPath    : Bool
    let parameters    : Parameters?
    let paramsEncoding: ParameterEncoding
    let queryItems    : [String:Any]?
    let decode        : (Data) throws -> Response

    init(method: Method = .get,
           path: Path,
     isUnicPath: Bool = false,
     queryItems: [String:Any]? = nil,
     parameters: Parameters? = nil,
 paramsEncoding: ParameterEncoding = JSONEncoding.default,
         decode: @escaping (Data) throws -> Response) {

        self.method         = method
        self.path           = path
        self.isUnicPath     = isUnicPath
        self.parameters     = parameters
        self.paramsEncoding = paramsEncoding
        self.queryItems     = queryItems
        self.decode         = decode
    }
}

extension Endpoint where Response: Swift.Decodable {
    
    convenience init(method: Method = .get,
                       path: Path,
                 isUnicPath: Bool = false,
                 queryItems: [String:Any]? = nil,
                 parameters: Parameters? = nil,
             paramsEncoding: ParameterEncoding = JSONEncoding.default) {

        self.init(method: method,
                    path: path,
              isUnicPath: isUnicPath,
              queryItems: queryItems,
              parameters: parameters,
          paramsEncoding: paramsEncoding) {

            try JSONDecoder().decode(Response.self, from: $0)
        }
    }
}

extension Endpoint where Response == Void {
    
    convenience init(method: Method = .get,
                       path: Path,
                 isUnicPath: Bool = false,
                 queryItems: [String:Any]? = nil,
                 parameters: Parameters? = nil,
             paramsEncoding: ParameterEncoding = JSONEncoding.default) {

        self.init( method: method,
                     path: path,
               isUnicPath: isUnicPath,
               queryItems: queryItems,
               parameters: parameters,
           paramsEncoding: paramsEncoding,
                   decode: { _ in () }
        )
    }
}

struct JSONArrayEncoding: ParameterEncoding {
    private let array: [Parameters]
    
    init(array: [Parameters]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}

