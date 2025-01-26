import SwiftUI

struct ContentView: View {
    @State private var todos: [TodoItem] = TodoService.loadTodos()
    @State private var showingAddTodo = false

    var body: some View {
        NavigationView {
            List {
                ForEach(todos.indices, id: \.self) { index in NavigationLink(destination: TodoDetailView(todo: $todos[index], todos: $todos)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(todos[index].title)
                                    .font(.headline)
                                
                                // Only show the periods if at least one period has been selected, otherwise it won't look right
                                if (todos[index].periods.count == 0){
                                    Text("\(DateFormatService.formattedDate(todos[index].dueDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                else{
                                    let formattedDate = DateFormatService.formattedDate(todos[index].dueDate)
                                    let periods = todos[index].sortedPeriods.joined(separator: ", ")
                                    let dueText = formattedDate + " (" + periods + ")"

                                    Text(dueText)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    //Text("(" + todos[index].sortedPeriods.joined(separator: ", ") + ") \(DateFormatService.formattedDate(todos[index].dueDate))")
                                }
                            }

                            Spacer() // Push the circle to the right

                            EventStatusService.eventStatus(for: todos[index].dueDate)
                                .frame(width: 15, height: 15)
                        }
                        .padding()
                    }
                }
                .onDelete(perform: removeTodo)
            }
            .navigationTitle("To-do List")
            .toolbar {
                Button(action: { showingAddTodo = true }) {
                    Image(systemName: "note.text.badge.plus")
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(todos: $todos)
            }
        }
    }

    private func removeTodo(at offsets: IndexSet) {
        TodoService.removeTodo(at: offsets, from: &todos)
    }
}

#Preview {
    ContentView()
}
