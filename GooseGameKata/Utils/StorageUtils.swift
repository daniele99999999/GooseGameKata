//
//  StorageUtils.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 22/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

public class StorageUtils {
    public static func loadPlist(name: String, rootKey: String?, bundle: Bundle = Bundle.main) -> Dictionary<String, Any>? {
        guard let path = bundle.url(forResource: name, withExtension: "plist") else {
            // genero il path
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            // carico i dati
            return nil
        }
        
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] ?? [:] else {
            // converto in plist e in dictionary
            return nil
        }
        
        if let rootKey = rootKey {
            // ho passato la root -> estraggo il dictionary interno
            
            guard let plistSubDictionary = plistDictionary[rootKey] as? [String: Any] else {
                return nil
            }
            
            return plistSubDictionary
        } else {
            // non ho passato la root -> restituisco tutto il plist
            return plistDictionary
        }
    }
    
    public static func loadJSON(name: String, bundle: Bundle = Bundle.main) -> Dictionary<String, Any>? {
        guard let path = bundle.url(forResource: name, withExtension: "json") else {
            // genero il path
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            // carico i dati
            return nil
        }
        
        guard let JSONDictionary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            // converto in plist e in dictionary
            return nil
        }
        
        return JSONDictionary
    }
    
    public static func loadJSON(name: String, bundle: Bundle = Bundle.main) -> Data? {
        guard let path = bundle.url(forResource: name, withExtension: "json") else {
            // genero il path
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            // carico i dati
            return nil
        }
        
        return data
    }
    
    public static func loadJSON(name: String, bundle: Bundle = Bundle.main) -> String? {
        guard let path = bundle.url(forResource: name, withExtension: "json") else {
            // genero il path
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            // carico i dati
            return nil
        }
        
        return data.string(encoding: .utf8)
    }
    
    public static func loadJSON<ResponseClass: Decodable>(name: String, bundle: Bundle = Bundle.main) -> ResponseClass? {
        guard let path = bundle.url(forResource: name, withExtension: "json") else {
            // genero il path
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            // carico i dati
            return nil
        }
        
        let dataMapped: ResponseClass? = self.objectDecode(data)
        
        return dataMapped
    }
    
    public static func objectDecode<ResponseClass: Decodable>(_ jsonData: Data) -> ResponseClass? {
        // converto con codable
        let jsonObject = try? JSONDecoder().decode(ResponseClass.self, from: jsonData)
        
        return jsonObject
    }
}
