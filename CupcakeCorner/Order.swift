//
//  Order.swift
//  CupcakeCorner
//
//  Created by Damien Chailloleau on 10/12/2023.
//

import Observation
import Foundation

@Observable
class Order: Codable {
    
//    var activities = [ActivityItem]() {
//        didSet {
//            if let encoded = try? JSONEncoder().encode(activities) {
//                UserDefaults.standard.set(encoded, forKey: "Activities")
//            }
//        }
//    }
//    
//    init() {
//        if let savedActivities = UserDefaults.standard.data(forKey: "Activities") {
//            if let decodedActivities = try? JSONDecoder().decode([ActivityItem].self, from: savedActivities) {
//                activities = decodedActivities
//                return
//            }
//        }
//        activities = []
//    }
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    let encoder = JSONEncoder()
    
    
    var type: Int = 0
    var quantity: Int = 3
    
    var name: String = ""
    var streetAddress: String = ""
    var city: String = ""
    var zip: String = ""
    
    var specialRequestEnabled: Bool = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // Price by amount of Cupcakes
        var cost = Decimal(quantity) * 2
        // Increasing price by choosing a type of Cupcake
        cost += Decimal(type) / 2
        // Increasing price by adding more Frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        // Increasing price by adding more sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
