import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var todos: [TodoItem]
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedPeriods: Set<String> = []  // Changed to Set to handle multiple selections
    @State private var isPeriodDropdownVisible = false  // Track visibility of the period dropdown
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    // Toggle button to show/hide period selection
                    Section {
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
                        
                        // Only show the dropdown when visible
                        if isPeriodDropdownVisible {
                            List(periodsList, id: \.self) { period in
                                MultipleSelectionRow(period: period, isSelected: selectedPeriods.contains(period)) {
                                    if selectedPeriods.contains(period) {
                                        selectedPeriods.remove(period)
                                    } else {
                                        selectedPeriods.insert(period)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New To-do")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addTodo()
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty || selectedPeriods.isEmpty)
                }
            }
        }
    }
    
    private func addTodo() {
        let newTodo = TodoItem(title: title, description: description, dueDate: dueDate, periods: Array(selectedPeriods))  // Convert Set to Array
        todos.append(newTodo)
        saveTodos()
    }

    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
}

#Preview {
    AddTodoView(todos: .constant([]))
}
