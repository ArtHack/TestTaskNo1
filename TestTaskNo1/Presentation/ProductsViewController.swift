//
//  ViewController.swift
//  TestTaskNo1
//
//  Created by Artem Khakimullin on 23.01.2025.
//

import UIKit

final class ProductsViewController: UIViewController {
    private var groupedData: [TransactionSummary] = []
    private let tableView = UITableView()
    private let presenter: ProductsPresenter

    init(presenter: ProductsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Products"
        setupTableView()
        presenter.fetchTransactions()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()
        let transactionSummary = groupedData[indexPath.row]
        content.text = transactionSummary.sku
        content.prefersSideBySideTextAndSecondaryText = true
        content.secondaryText = "\(transactionSummary.count) transactions"
        content.secondaryTextProperties.font = .systemFont(ofSize: 16, weight: .light)
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
}

extension ProductsViewController: UITableViewDelegate {

}

extension ProductsViewController: ProductsPresenterProtocol {
    func didUpdateTransactions(_ transactions: [TransactionSummary]) {
        self.groupedData = transactions
        tableView.reloadData()
    }

}
