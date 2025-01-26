import Foundation

class TodoService {
    
    // Save todos to UserDefaults
    static func saveTodos(_ todos: [TodoItem]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }

    // Load todos from UserDefaults
    static func loadTodos() -> [TodoItem] {
        if let savedData = UserDefaults.standard.data(forKey: "todos"),
           let decodedTodos = try? JSONDecoder().decode([TodoItem].self, from: savedData) {
            return decodedTodos
        }
        return []
    }

    // Remove a todo from the list
    static func removeTodo(at offsets: IndexSet, from todos: inout [TodoItem]) {
        todos.remove(atOffsets: offsets)
        saveTodos(todos)
    }

    // Update the todo in the todos list
    static func updateTodo(
        todo: inout TodoItem,
        title: String,
        description: String,
        dueDate: Date,
        periods: Set<String>
    ) {
        todo.title = title
        todo.description = description
        todo.dueDate = dueDate
        todo.periods = Array(periods) // Convert Set back to an array
    }
}
