//
//  TasksViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 04/05/23.
//

import UIKit

class TasksViewController: UIViewController {
    
    private var todoItems = [TodoItem]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupNavItems()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavItems() {
        let addTodoButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addTodo))
        addTodoButton.tintColor = .white
        navigationItem.rightBarButtonItem = addTodoButton
    }
    
    @objc private func addTodo() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text else { return }
            self?.addTodoItem(title: title)
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func addTodoItem(title: String) {
        let todoItem = TodoItem(title: title, completed: false)
        todoItems.append(todoItem)
        tableView.reloadData()
    }
    
    private func updateTodoItem(at index: Int, withTitle title: String) {
        todoItems[index].title = title
        tableView.reloadData()
    }
    
    private func deleteTodoItem(at index: Int) {
        todoItems.remove(at: index)
        tableView.reloadData()
    }
    
}


extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todoItem = todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.completed ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTodoItem(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            self?.editTodoItem(at: indexPath.row)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    private func editTodoItem(at index: Int) {
        let alert = UIAlertController(title: "Edit Todo", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.todoItems[index].title
        }
        let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text else { return }
            self?.updateTodoItem(at: index, withTitle: title)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
