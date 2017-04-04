//
//  CartItemCell.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import UIKit
import RxSwift

class CartItemCell: UITableViewCell {

    @IBOutlet weak var itemBrandLabel: UILabel?
    @IBOutlet weak var itemPriceLabel: UILabel?
    @IBOutlet weak var itemQuantityLabel: UILabel?

    var item: CartItem = CartItem() {
        didSet {
            item
                .rx_quantity
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribeNext { [weak self] (_) in
                    self?.updateUI()
                }
                .addDisposableTo(disposeBag)
        }
    }

    private let disposeBag: DisposeBag = DisposeBag()

    func updateUI() {
        itemBrandLabel?.text = item.chocolate.brand
        itemPriceLabel?.text = "$\(item.chocolate.price)"
        itemQuantityLabel?.text = "x\(item.quantity)"
    }

    @IBAction func increaseQuantity() {
        item.increaseQuantity()
    }

    @IBAction func decreaseQuantity() {
        item.decreaseQuantity()
    }
}
