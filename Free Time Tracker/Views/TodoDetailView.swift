import SwiftUI

struct TodoDetailView: View {
    @Binding var todo: TodoItem
    @Binding var todos: [TodoItem]

    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedDueDate: Date
    @State private var editedPeriods: Set<String>  // Use Set to prevent duplicates
    @State private var isPeriodDropdownVisible = false  // Track visibility of the period dropdown
    
    init(todo: Binding<TodoItem>, todos: Binding<[TodoItem]>) {
        self._todo = todo
        self._todos = todos
        _editedTitle = State(initialValue: todo.wrappedValue.title)
        _editedDescription = State(initialValue: todo.wrappedValue.description)
        _editedDueDate = State(initialValue: todo.wrappedValue.dueDate)
        _editedPeriods = State(initialValue: Set(todo.wrappedValue.periods)) // Initialize as a set of periods
    }

    var body: some View {
        ScrollView { // Wrap everything inside a ScrollView
            VStack(alignment: .leading, spacing: 20) {
                if isEditing {
                    TextField("Title", text: $editedTitle)
                        .font(.largeTitle)
                        .bold()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    DatePicker("Due Date: ", selection: $editedDueDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .font(.headline)
                    
                    HStack {
                        Text("Period(s): ")
                            .font(.headline)
                        
                        // Toggle button to show/hide period selection dropdown
                        Button(action: {
                            withAnimation {
                                isPeriodDropdownVisible.toggle()
                            }
                        }) {
                            HStack {
                                Text("Choose Periods")
                                Spacer()
                                Image(systemName: isPeriodDropdownVisible ? "chevron.up.circle" : "chevron.down.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    // Only show the dropdown when visible
                    if isPeriodDropdownVisible {
                        LazyVStack(alignment: .leading, spacing: 5) {
                            ForEach(periodsList, id: \.self) { period in
                                MultipleSelectionRow(period: period, isSelected: editedPeriods.contains(period)) {
                                    if editedPeriods.contains(period) {
                                        editedPeriods.remove(period)
                                    } else {
                                        editedPeriods.insert(period)
                                    }
                                }
                                .padding(.vertical, 5)  // Add some padding to each row
                                .background(Color(UIColor.systemGray6))  // Optional: Add a background color to make the rows distinguishable
                                .cornerRadius(8)  // Optional: Add rounded corners for a better look
                            }
                        }
                        .frame(maxWidth: .infinity) // Ensures the LazyVStack takes full width available
                        .padding(.top, 5)  // Optional: Add top padding for better visual spacing
                    }
                    
                    Text("Description: ")
                        .font(.headline)
                    TextEditor(text: $editedDescription)
                        .font(.body)
                        .border(Color.gray, width: 1)
                        .frame(height: 150) // Set a height for the description field
                } else {
                    Text(todo.title)
                        .font(.largeTitle)
                        .bold()
                    
                    if (todo.periods.count == 0){
                        Text("For: \(DateFormatService.formattedDate(todo.dueDate)) (No period specified)")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    else{
                        Text("For: \(DateFormatService.formattedDate(todo.dueDate)) (\(todo.sortedPeriods.joined(separator: ", ")))")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    

                    Text(todo.description)
                        .font(.body)
                        .padding(.top, 10)
                }
            }
            .padding(.leading) // Align to the very left
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
        .navigationTitle("Details")
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
            if !isEditing {
                saveChanges()
            }
        }) {
            Text(isEditing ? "Save" : "Edit")
                .font(.headline)
                .foregroundColor(.blue)
        })
    }

    private func saveChanges() {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            // Update todo using the service method
            TodoService.updateTodo(todo: &todos[index], title: editedTitle, description: editedDescription, dueDate: editedDueDate, periods: editedPeriods)
            TodoService.saveTodos(todos)
        }
    }
}

#Preview {
    TodoDetailView(
        todo: .constant(TodoItem(title: "Sample Task", description: "This is a sample task description.", dueDate: Date(), periods: ["Period 1"])),
        todos: .constant([
            TodoItem(title: "Sample Task", description: "This is a sample task description.", dueDate: Date(), periods: ["Period 1"])
        ])
    )
}
