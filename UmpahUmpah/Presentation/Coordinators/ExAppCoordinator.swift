//
//  ExAppCoordinator.swift
//  UmpahUmpah
//
//  Created by chang hyen yun on 5/29/25.
//

import SwiftUI

struct ExAppCoordinator {
    static func makeTodoListView() -> some View {
        let dataSource = ExTodoLocalDataSource()
        let repository = ExTodoRepository(localDataSource: dataSource)
        let useCase = ExGetTodosUseCase(repository: repository)
        let viewModel = ExTodoListViewModel(getTodosUseCase: useCase)
        return ExTodoListView(viewModel: viewModel)
    }
}

