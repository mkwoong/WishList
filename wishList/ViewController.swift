//
//  ViewController.swift
//  urlPractice
//
//  Created by 문기웅 on 4/15/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func numberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else {return}
            
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                self.priceLabel.text = "$\(self.numberFormatter(number: (currentProduct.price)))"
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imageView.image = image }
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
    }
    
    private func fetchRemoteProduct() {
        let productID = Int.random(in: 1 ... 100)
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
    }
}
