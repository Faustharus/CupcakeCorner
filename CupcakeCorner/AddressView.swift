//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Damien Chailloleau on 10/12/2023.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    enum FocusedField {
        case name, streetAddress, city, zip
    }
    
    @FocusState private var isCurrentlyOn: FocusedField?
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .focused($isCurrentlyOn, equals: .name)
                TextField("Street Address", text: $order.streetAddress)
                    .focused($isCurrentlyOn, equals: .streetAddress)
                TextField("City", text: $order.city)
                    .focused($isCurrentlyOn, equals: .city)
                TextField("Zip Code", text: $order.zip)
                    .focused($isCurrentlyOn, equals: .zip)
            }
            .keyboardType(.default)
            
            Section {
                NavigationLink("Check Out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Button("Close Keyboard") {
//                    if isCurrentlyOn == .name || isCurrentlyOn == .streetAddress || isCurrentlyOn == .city || isCurrentlyOn == .zip {
//                        isCurrentlyOn = nil
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    AddressView(order: Order())
}
