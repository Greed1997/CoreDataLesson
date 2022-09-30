//
//  TaskListViewController.swift
//  CoreData2
//
//  Created by Александр on 29.09.2022.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Нужно будет перенести в StorageManager
    private let cellID = "task"
    private var taskList: [TaskEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID) // определяем ячейку в tableView
        setUpNavigationBar()
        fetchData()
    }
    private func setUpNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance() // класс отвечает за внешний вид навигейшен бара
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // foregroundColor - цвет текста
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // largeTitleTextAttributes - характеристика текста для large Title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, // Виды изображения кнопок
            target: self, // Место реализации кнопки
            action: #selector(addNewTask)  // что должно делать при нажатии
        )
        
        navigationController?.navigationBar.tintColor = .white // цвет текста в navigationBar
        navigationController?.navigationBar.standardAppearance = navBarAppearance // для не largeTitleNavBar
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance // для largeTitleNavBar
        
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    private func fetchData() {
        let fetchRequest = TaskEntity.fetchRequest() // запрос к базе данных TaskEntity. Говорим базе: "Мы хотим получить объекты с типом TaskEntity"
        
        do {
            taskList = try context.fetch(fetchRequest) // данные метод принимает запрос и суть этого запроса заключается в том, что в нем мы определяем тип данных, который нам нужно раздобыть из базы. На выходе получаем массив [TaskEntity]
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in // так как alertController содержит в себе массив текстовых полей, то мы просто можем извлечь из него текстовое поле
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? TaskEntity else { return }
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0) // индекс строки, по которой мы будем добавлять новую ячейку
        tableView.insertRows(at: [cellIndex], with: .automatic) // добавление ячеек
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - TaskListViewControllerDelegate
extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}
