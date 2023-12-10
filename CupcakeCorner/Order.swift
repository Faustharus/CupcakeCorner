//
//  Order.swift
//  CupcakeCorner
//
//  Created by Damien Chailloleau on 10/12/2023.
//

import Observation
import Foundation

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type: Int = 0
    var quantity: Int = 3
    
    var specialRequestEnabled: Bool = false
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
}
