//
//  TasksPresenter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift

class TasksPresenter: TasksPresenterProtocol {
    
    private weak var view: TasksViewProtocol?
    private var getTasksUseCase: UseCase<Void, TasksResponse>
    private let disposeBag = DisposeBag()
    
    init(getTasksUseCase: UseCase<Void, TasksResponse>) {
        self.getTasksUseCase = getTasksUseCase
    }
    
    func attachView(view: TasksViewProtocol) {
        self.view = view
    }
    
    func getTasks() {
        view?.showLoader()
        do {
            try getTasksUseCase.execute(params: Void())
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] response in
                    self?.view?.hideLoader()
                    if response.tasksArray.isEmpty {
                        self?.view?.showError(message: "No file to get tasks from")
                    }
                    self?.view?.showTasks(tasks: response)
                }, onFailure: { [weak self] error in
                    self?.view?.hideLoader()
                    debugPrint("Error get tasks: \(error.localizedDescription)")
                    self?.view?.showError(message: "Something went wrong getting your tasks")
                }, onDisposed: nil).disposed(by: disposeBag)
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
}
