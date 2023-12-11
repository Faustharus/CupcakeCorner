//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Damien Chailloleau on 10/12/2023.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 233)
                    case .failure(_):
                        Text("Error loading the image")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        fatalError()
                        
                    }
                    
                    Text("Your total cost is: \(order.cost, format: .currency(code: "EUR"))").font(.title)
                    
                    Button {
                        Task {
                            await placeOrder()
                        }
                    } label: {
                        Text("Place Order")
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thnak you", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView(order: Order())
    }
}

extension CheckoutView {
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failted to encode")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way !"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
        }
    }
    
}
