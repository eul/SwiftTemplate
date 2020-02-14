//
//  FileStorage.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

class FileStorage {
    
    public var rootDirectory :URL!
    
    init() {
        
        let fileManager = FileManager.default
        
        rootDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    public func save<T:Encodable>(dataToSave: T, key: String) {
        
        do {
            
            let fileURL = rootDirectory.appendingPathComponent(key)
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            }catch { }
            
            let jsonEncoder = JSONEncoder()
            let jsonData    = try jsonEncoder.encode(dataToSave)
            
            try jsonData.write(to: fileURL)
            
        } catch {
            print(error)
        }
    }
    
    public func get<T:Decodable>(key: String) -> T? {
        
        let fileURL = rootDirectory.appendingPathComponent(key)
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let user = try decoder.decode(T.self, from: data)
            
            return user
            
        } catch {
            
            print(error)
        }
        
        return nil
    }
    
    public func getArray<T:Decodable>(key: String) -> [T] {
        
        let fileURL = rootDirectory.appendingPathComponent(key)
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let arrayValue = try decoder.decode(Array<T>.self, from: data)
            
            return arrayValue
            
        } catch {
            
            print(error)
        }
        
        return []
    }
    
    //MARK:--
//    public func save(user: UserData) {
//
//        do {
//
//            let fileURL = rootDirectory.appendingPathComponent("userData")
//
//            do {
//                try FileManager.default.removeItem(at: fileURL)
//            }catch { }
//
//            let jsonEncoder = JSONEncoder()
//            let jsonData    = try jsonEncoder.encode(user)
//
//            try jsonData.write(to: fileURL)
//
//        } catch {
//            print(error)
//        }
//    }
//
//    public func removeUser() {
//
//        let fileURL = rootDirectory.appendingPathComponent("userData")
//
//        do {
//            try FileManager.default.removeItem(at: fileURL)
//        }catch { }
//    }
//
//    public func getUser() -> UserData? {
//
//        let fileURL = rootDirectory.appendingPathComponent("userData")
//
//        do {
//            let data = try Data(contentsOf: fileURL)
//
//            let decoder = JSONDecoder()
//            let user = try decoder.decode(UserData.self, from: data)
//
//            return user
//
//        } catch {
//
//            print(error)
//        }
//
//        return nil
//    }
}

