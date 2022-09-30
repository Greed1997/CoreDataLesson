//
//  ViewController.swift
//  CoreData2
//
//  Created by Александр on 29.09.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    private var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
}

