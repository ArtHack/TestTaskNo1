//
//  PrepareData.swift
//  TestTaskNo1
//
//  Created by Artem Khakimullin on 28.01.2025.
//

import Foundation

protocol ProductsPresenterProtocol: AnyObject {
    func didUpdateTransactions(_ transactions: [TransactionSummary])
}

class ProductsPresenter {

    private let dataClient: DataClient
    weak var view: ProductsPresenterProtocol?

    init(dataClient: DataClient) {
        self.dataClient = dataClient
    }

    func fetchTransactions() {
        let data = dataClient.loadTransactios()
        let groupedTransactions = groupTransacions(data)
        view?.didUpdateTransactions(groupedTransactions)
    }

    private func groupTransacions(_ transactions: [TransactionsData]) -> [TransactionSummary] {
        var transactionCount: [String: Int] = [:]

        for transaction in transactions {
            transactionCount[transaction.sku, default: 0] += 1
        }

        return transactionCount.map {
            TransactionSummary(sku: $0.key, count: $0.value)
        } .sorted {
            $0.sku < $1.sku
        }
    }
}
