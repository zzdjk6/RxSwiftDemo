//
//  CartViewController.swift
//  RxSwiftDemo
//
//  Created by 陈圣晗 on 04/04/2017.
//  Copyright © 2017 Thor Chen. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD

class CartViewController: UIViewController {

    @IBOutlet weak var amountPriceLabel: UILabel?
    @IBOutlet weak var amountQuantityLabel: UIButton?

    var viewModel: CartViewModel = CartViewModel()

    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel
            .rx_amountPrice
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (price) in
                self?.amountPriceLabel?.text = "$\(price)"
            }
            .addDisposableTo(disposeBag)

        viewModel
            .rx_amountQuantity
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (quantity) in
                self?.amountQuantityLabel?.setTitle( "🍫\(quantity)", forState: .Normal)
            }
            .addDisposableTo(disposeBag)

        resetCart()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? CartItemListViewController {
            vc.viewModel = viewModel
        }
    }

    @IBAction func resetCart() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        viewModel
            .rx_loadItemList()
            .delaySubscription(0.5, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribeNext { (_) in
                hud.hideAnimated(true)
            }
            .addDisposableTo(disposeBag)
    }

    @IBAction func addSupply() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        viewModel
            .rx_addSupply()
            .delaySubscription(0.2, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance) // if not on Main Thread, the app should crash
            .doOn { (_) in
                hud.hideAnimated(true)
            }
            .doOnError { [weak self] (error) in
                let message = (error as NSError).localizedDescription
                let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "Got it", style: .Default, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    @IBAction func notifyCartConfirmed() {
        RxEventHub
            .sharedHub
            .notify(CartConfirmedEventProvider(), data: (quantity: viewModel.amountQuantity, price: viewModel.amountPrice))
    }
}

