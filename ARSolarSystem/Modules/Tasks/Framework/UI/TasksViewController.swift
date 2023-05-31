//
//  TasksViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 04/05/23.
//

import UIKit
import Toast
import Alamofire

class TasksViewController: UIViewController {
    
    private var todoItems = [Task]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
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
        //let addTodoButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addTodo))
        let addFileButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addFile))
        //addTodoButton.tintColor = .white
        addFileButton.tintColor = .white
        navigationItem.rightBarButtonItems = [addFileButton]
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
        let todoItem = Task(title: title, date: "", description: "", done: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
            let task = todoItems[indexPath.row]
            cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { [weak self] _, _, completionHandler in
            self?.completeTodoItem(at: indexPath.row)
            completionHandler(true)
        }
        completeAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    private func completeTodoItem(at index: Int) {
        todoItems[index].done = true
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

extension TasksViewController: TasksViewProtocol {
    
    func showTasks(tasks: TasksResponse) {
        todoItems.removeAll()
        todoItems.append(contentsOf: tasks.tasksArray)
        tableView.reloadData()
    }
    
    func showLoader() {
        view.makeToastActivity(.center)
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
        guard let fileURL = urls.first else { return }
        uploadCSVFile(fileURL: fileURL)
    }
    
    func uploadCSVFile(fileURL: URL) {
        guard let csvData = try? Data(contentsOf: fileURL) else { return}
        
        let url = "http://localhost:3000/tasks/file"
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(csvData, withName: "taskFile", fileName: "data.csv", mimeType: "text/csv")
        }, to: url).response { response in
            debugPrint(response)
        }
        showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.presenter?.getTasks()
        }
    }
}
