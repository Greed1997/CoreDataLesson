//
//  TaskViewController.swift
//  CoreData2
//
//  Created by Александр on 30.09.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    var delegate: TaskViewControllerDelegate?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Нужно будет перенести в StorageManager
    
    private lazy var newTaskTextField: UITextField = { // lazy позволяет осуществить отложенную инициализацию свойства. Обязательно при программной верстке интерфейса
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = { // создать кастомный класс: UIButton
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Save Task", for: .normal) // for: - состояние кнопки
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // размер текста
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.9, green: 0.34, blue: 0.19, alpha: 1)
        button.setTitle("Cancel", for: .normal) // for: - состояние кнопки
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // размер текста
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(newTaskTextField, saveButton, cancelButton)
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView...) { // располагает view на superView
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        newTaskTextField.translatesAutoresizingMaskIntoConstraints = false // translatesAutoresizingMaskIntoConstraints позволяет(не позволяет) работать через интерфейс билдер
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newTaskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80), // anchor = якорь; equalTo = до куда
            newTaskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            newTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ]) // NSLayoutConstraint отвечает за констрейнты
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: newTaskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func save() {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context) else { return } // для создания объекта нужно создать описание сущности; в entityDescription содержится всё, что сделано в CoreData2
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? TaskEntity else { return }
        task.title = newTaskTextField.text // нужно добавить проверку на пустоту, чтобы не добавлять пустые таски
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
