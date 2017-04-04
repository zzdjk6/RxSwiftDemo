//
//  CartItemListViewController.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import UIKit
import RxSwift

class CartItemListViewController: UITableViewController {

    var viewModel: CartViewModel = CartViewModel()

    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel
            .rx_itemList
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (_) in
                self?.tableView?.reloadData()
            }
            .addDisposableTo(disposeBag)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CartItemCell.self), forIndexPath: indexPath) as! CartItemCell

        if let cartItem = viewModel.itemAt(indexPath) {
            cell.item = cartItem
        }

        cell.updateUI()

        return cell
    }
}
