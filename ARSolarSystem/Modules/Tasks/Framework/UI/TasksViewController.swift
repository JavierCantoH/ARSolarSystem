//
//  TasksViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 04/05/23.
//

import UIKit
import Toast

class TasksViewController: UIViewController {
    
    private var todoItems = [TodoItem]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        return tableView
    }()
    
    private lazy var toastStyleMissElements: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .red
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    private lazy var toastStyleComplete: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .green
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    var presenter: TasksPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.attachView(view: self)
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getTasks()
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupNavItems() {
        let addTodoButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addTodo))
        let addFileButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addFile))
        addTodoButton.tintColor = .white
        addFileButton.tintColor = .white
        navigationItem.rightBarButtonItems = [addTodoButton, addFileButton]
    }
    
    @objc private func addTodo() {
        let alert = UIAlertController(title: "Nueva Tarea", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let addAction = UIAlertAction(title: "Agregar", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {
                let emptyTitleAlert = UIAlertController(title: "Error", message: "Please enter a title for the task.", preferredStyle: .alert)
                emptyTitleAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(emptyTitleAlert, animated: true, completion: nil)
                return
            }
            self?.addTodoItem(title: title)
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func addTodoItem(title: String) {
        let todoItem = TodoItem(title: title , completed: false)
        todoItems.append(todoItem)
        tableView.reloadData()
        let contentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let bottomInset = max(tableViewHeight - contentHeight, 0)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8 + bottomInset, right: 0)
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
        cell.backgroundColor = .lightGray
        cell.textLabel?.font = UIFont(name: "Avenir-light", size: 25)
        cell.textLabel?.textAlignment = .center
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        cell.textLabel?.numberOfLines = 0 // set the number of lines to 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.frame = cell.bounds // center the label vertically
        cell.accessoryType = todoItem.completed ? .checkmark : .none
        
        let bottomMargin = CGFloat(16)
        let topMargin = CGFloat(0)
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: topMargin, left: 0, bottom: bottomMargin, right: 0))
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 8),
            separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0 // Set cell height
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

extension TasksViewController: TasksViewProtocol {
    
    func showTasks(tasks: TasksResponse) {
        // TODO SHOW TASKS IN TABLE VIEW
    }
    
    func showLoader() {
        view.makeToastActivity(.bottom)
    }
    
    func hideLoader() {
        view.hideToastActivity()
    }
    
    func showError(message: String) {
        if let image = UIImage(systemName: "exclamationmark.square.fill") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast(message, duration: 2.0, position: .center, title: "Ups!", image: tintedImage, style: toastStyleMissElements)
        }
    }
}

extension TasksViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else {
            // Handle error, no URL available
            return
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(pickedURL.lastPathComponent)

        do {
            let fileManager = FileManager.default
            try fileManager.moveItem(at: pickedURL, to: destinationURL)

            let apiURL = URL(string: "http://localhost:3000/tasks")!
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"

            let session = URLSession.shared

            let task = session.uploadTask(with: request, fromFile: destinationURL) { responseData, response, error in
                if let error = error {
                    // Handle the error
                    print("Error uploading file: \(error)")
                    return
                }

                // Handle the API response
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // File uploaded successfully
                        print("File uploaded successfully")
                    } else {
                        // Handle other HTTP status codes
                        print("Error uploading file. HTTP status code: \(httpResponse.statusCode)")
                    }
                }
            }

            task.resume()
        } catch {
            // Handle error while saving the file
            print("Error saving file: \(error)")
        }
    }
}
