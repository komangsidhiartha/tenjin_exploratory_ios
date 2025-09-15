//
//  ContentView.swift
//  TenjinIosSdkExploratory
//
//  Created by Komang Sidhi Artha on 14/09/25.
//

import SwiftUI
import TenjinSDK

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("eventWithName") {
                TenjinSDK.sendEvent(withName: "swipe_right")
            }
            .padding()
            
            Button("Send eventWithNameAndValue") {
                TenjinSDK.sendEvent(withName: "item", andValue: 100)
            }
            .padding()
            
            Button("Send Transaction with Receipt") {
                TenjinSDK.transaction(withProductName: "productId", andCurrencyCode: "USD", andQuantity: 1, andUnitPrice: 3.80, andTransactionId: "transactionId", andReceipt: Data("iosReceipt".utf8))
            }
            .padding()
            
            Button("Send Transaction") {
                TenjinSDK.transaction(
                    withProductName: "productId",
                    andCurrencyCode: "USD",
                    andQuantity: 1,
                    andUnitPrice: 3.80
                )
            }
            .padding()
            
            Button("Set Customer Id") {
                TenjinSDK.setCustomerUserId("test_user_id")
            }
            .padding()
            
            Button("Get Customer Id") {
                guard let userId = TenjinSDK.getCustomerUserId() else {
                    return
                }
                print(userId)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
