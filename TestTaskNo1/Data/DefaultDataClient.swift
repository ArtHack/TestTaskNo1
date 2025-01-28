//
//  DataManager.swift
//  TestTaskNo1
//
//  Created by Artem Khakimullin on 27.01.2025.
//

import Foundation

protocol DataClient {
    func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: (Result<T, Error>) -> Void)
    func loadTransactios() -> [TransactionsData]
}

struct DefaultDataClient: DataClient {
    var transactions: [TransactionsData] = []

    private let decoder: PropertyListDecoder
    init(decoder: PropertyListDecoder = PropertyListDecoder()) {
        self.decoder = decoder
    }

    func loadTransactios() -> [TransactionsData] {
        var transactions: [TransactionsData] = []

        guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist") else {
            assertionFailure("Bundle File Not Found")
            return transactions
        }
        let url = URL(filePath: path)
        do {
            let data = try! Data(contentsOf: url)
            parse(data: data, type: [TransactionsData].self) { result in
                switch result {
                case .success(let parcedTransactions):
                    transactions = parcedTransactions
                case .failure(let error):
                    assertionFailure("Error parsing transactions: \(error)")
                }
            }
            return transactions
        }
    }

    func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(error))
        }
    }
}
