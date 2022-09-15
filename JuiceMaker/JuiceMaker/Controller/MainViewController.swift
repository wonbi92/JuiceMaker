//
//  JuiceMaker - MainViewController.swift
//  Created by Wonbi, woong
//

import UIKit

class MainViewController: UIViewController {
    private let store = FruitStore(stockCount: 10)
    private lazy var juiceMaker = JuiceMaker(store: store)
    
    @IBOutlet weak var strawberryBananaOrder: UIButton!
    @IBOutlet weak var mangoKiwiOrder: UIButton!
    @IBOutlet weak var strawberryOrder: UIButton!
    @IBOutlet weak var bananaOrder: UIButton!
    @IBOutlet weak var pineappleOrder: UIButton!
    @IBOutlet weak var kiwiOrder: UIButton!
    @IBOutlet weak var mangoOrder: UIButton!
    @IBOutlet var fruitCountLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateStockCount()
    }
    
    @IBAction private func tappedModifyBarButton(_ sender: Any) {
        presentEditView()
    }
    
    @IBAction private func tappedOrderButton(_ sender: UIButton) {
        var juice: Juice?
        
        switch sender {
        case strawberryBananaOrder:
            juice = .strawberryBananaJuice
        case mangoKiwiOrder:
            juice = .mangoKiwiJuice
        case strawberryOrder:
            juice = .strawberryJuice
        case bananaOrder:
            juice = .bananaJuice
        case pineappleOrder:
            juice = .pineappleJuice
        case kiwiOrder:
            juice = .kiwiJuice
        case mangoOrder:
            juice = .mangoJuice
        default:
            juice = nil
        }
        
        checkCanMakeJuice(juice)
    }
    
    private func updateStockCount() {
        var newStock = store.stock
        
        for fruitCountLabel in fruitCountLabels {
            if newStock.isEmpty { return }
            fruitCountLabel.text = String(newStock.removeFirst())
        }
    }
    
    private func presentEditView() {
        guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "EditNavigationController") as? UINavigationController else { return }
        navigationController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        guard let editViewController = navigationController.viewControllers.first as? EditViewController else { return }
        
        editViewController.setStore(from: store)
        
        present(navigationController, animated: true)
    }
    
    private func checkCanMakeJuice(_ juice: Juice?) {
        guard let juice = juice else { return }
        
        if juiceMaker.makeJuice(juice) {
            updateStockCount()
            self.resultAlert(isSuccess: true, juiceName: juice.name)
        } else {
            self.resultAlert(isSuccess: false)
        }
    }
    
    private func resultAlert(isSuccess: Bool, juiceName: String = "") {
        let message = isSuccess ? juiceName + AlertMessage.successMessage : AlertMessage.failureMessage
        let comfirm = isSuccess ? AlertMessage.successComfirm : AlertMessage.failureComfirm
        let handler: ((UIAlertAction) -> Void)? = isSuccess ? nil : { _ in self.presentEditView() }
        
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        let comfirmAction = UIAlertAction(title: comfirm,
                                          style: .default,
                                          handler: handler)
        
        if isSuccess {
            alert.addAction(comfirmAction)
        } else {
            let cencelAction = UIAlertAction(title: AlertMessage.failureCencel,
                                             style: .cancel,
                                             handler: nil)
            alert.addAction(comfirmAction)
            alert.addAction(cencelAction)
        }
        
        present(alert, animated: true)
    }
}
