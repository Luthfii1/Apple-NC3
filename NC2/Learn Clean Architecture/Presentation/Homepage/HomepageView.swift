//
//  Homepage.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 09/07/24.
//

import SwiftUI
import SwiftData

// Homepage view just has a responsbility for displaying interface
struct HomepageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: HomepageViewModel
    @State private var isCreated: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(vm.todos) { todo in
                        TodoView(desc: todo.title, isCompleted: todo.completed)
                    }
                    .onDelete(perform: { indexSet in
                        Task {
                            await vm.deleteTodo(at: indexSet)
                        }
                    })
                }
                .navigationTitle("Your Todos")
                .task {
                    await vm.getTodos()
                }
                .refreshable {
                    Task {
                        await vm.getTodos()
                    }
                }
                
                CreateButton(action: {
                    isCreated.toggle()
                })
                
            }
            .sheet(isPresented: $isCreated, content: {
                TodoFormSheet(isCreated: $isCreated)
                    .environmentObject(vm)
            })
        }
    }
}

//struct Homepage_Previews: PreviewProvider {
//    let container : ModelContainer
//
//    container = try ModelContainer(for: Todo.self)
//
//    let getLocalTodos = GetLocalTodos(modelContext: container.mainContext)
//    let getRemoteTodos = GetRemoteTodos()
//    let getTodosRepo = GetTodosRepo(localData: getLocalTodos, remoteData: getRemoteTodos)
//    let getTodosUseCase = GetTodosUseCase(getTodosRepo: getTodosRepo)
//    let homepageViewModel = HomepageViewModel(getTodosUseCase: getTodosUseCase)
//
//    static var previews: some View {
//        HomepageView(vm: homepageViewModel)
//            .modelContainer(container)
//    }
//}
