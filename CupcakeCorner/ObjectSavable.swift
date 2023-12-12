//
//  ObjectSavable.swift
//  CupcakeCorner
//
//  Created by Damien Chailloleau on 12/12/2023.
//

import Foundation

protocol ObjectSavable {
    func setObject<Order>(_ order: Order, forKey: String) throws where Order: Encodable
    func getObject<Order>(forKey: String, castTo type: Order.Type) throws -> Order where Order: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode data into given object type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Order>(_ order: Order, forKey: String) throws where Order : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(order)
            set(data, forKey: "CurrentAddress")
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Order>(forKey: String, castTo type: Order.Type) throws -> Order where Order : Decodable {
        guard let data = data(forKey: "CurrentAddress") else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
