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
    
    @State private var isShowingAlert: Bool = false
    
    @FocusState private var isCurrentlyOn: FocusedField?
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .focused($isCurrentlyOn, equals: .name)
                    .submitLabel(.next)
                TextField("Street Address", text: $order.streetAddress)
                    .focused($isCurrentlyOn, equals: .streetAddress)
                    .submitLabel(.next)
                TextField("City", text: $order.city)
                    .focused($isCurrentlyOn, equals: .city)
                    .submitLabel(.next)
                TextField("Zip Code", text: $order.zip)
                    .focused($isCurrentlyOn, equals: .zip)
                    .submitLabel(.done)
            }
            .keyboardType(.default)
            
            Section {
                Button("Check Out") {
                    saveAddress()
                    isShowingAlert = true
                }
            }
            .disabled(!order.hasValidAddress)
            
            Section {
                Button {
                    loadAddress()
                } label: {
                    Text("Use Stored Address ?")
                }
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Is this the correct address ?", isPresented: $isShowingAlert) {
            NavigationLink("Yes") {
                CheckoutView(order: order)
            }
            Button("No", role: .cancel) {
                reset()
                isShowingAlert = false
            }
        } message: {
            Text("The Address will be automatically stored in the phone")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isCurrentlyOn == .name || isCurrentlyOn == .streetAddress || isCurrentlyOn == .city || isCurrentlyOn == .zip {
                        isCurrentlyOn = nil
                    }
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

#Preview {
    AddressView(order: Order())
}

extension AddressView {
    
    func saveAddress() {
        let newAddress = [order.name, order.streetAddress, order.city, order.zip]
        let userDefaults = UserDefaults.standard
        do {
            try userDefaults.setObject(newAddress, forKey: "CurrentAddress")
        } catch {
            print("Error Detected : \(error.localizedDescription) !")
        }
    }
    
    func loadAddress() {
        let userDefaults = UserDefaults.standard
        do {
            let newAddress = try userDefaults.getObject(forKey: "CurrentAddress", castTo: [String].self)
            
            order.name = newAddress[0]
            order.streetAddress = newAddress[1]
            order.city = newAddress[2]
            order.zip = newAddress[3]
            
            isCurrentlyOn = .zip
        } catch {
            print("Error Detected : \(error.localizedDescription) !")
        }
    }
    
    func reset() {
        order.name = ""
        order.streetAddress = ""
        order.city = ""
        order.zip = ""
    }
    
}
