//
//  ST+URL.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

extension URL {
    
    /**
     Add, update, or remove a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     - parameter value: the value to replace the query string parameter, nil will remove item
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItem(_ name: String, value: Any?) -> String {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteString
        }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { $0.name.lowercased() != name.lowercased() } ?? []
        
        // Skip if nil value
        if let value = value {
            urlComponents.queryItems?.append(URLQueryItem(name: name, value: "\(value)"))
        }
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Add, update, or remove a query string parameters from the URL
     
     - parameter url:   the URL
     - parameter values: the dictionary of query string parameters to replace
     
     - returns: the URL with the mutated query string
     */
    func appendingQueryItems(_ contentsOf: [String: Any?]) -> String {
        guard var urlComponents = URLComponents(string: absoluteString), !contentsOf.isEmpty else {
            return absoluteString
        }
        
        let keys = contentsOf.keys.map { $0.lowercased() }
        
        urlComponents.queryItems = urlComponents.queryItems?
            .filter { !keys.contains($0.name.lowercased()) } ?? []
        
        urlComponents.queryItems?.append(contentsOf: contentsOf.compactMap {
            guard let value = $0.value else { return nil } //Skip if nil
            return URLQueryItem(name: $0.key, value: "\(value)")
        })
        
        return urlComponents.string ?? absoluteString
    }
    
    /**
     Removes a query string parameter from the URL
     
     - parameter url:   the URL
     - parameter key:   the key of the query string parameter
     
     - returns: the URL with the mutated query string
     */
    func removeQueryItem(_ name: String) -> String {
        return appendingQueryItem(name, value: nil)
    }
}
