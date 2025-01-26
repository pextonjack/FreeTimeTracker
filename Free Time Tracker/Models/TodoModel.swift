import Foundation
import SwiftUI

struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var dueDate: Date
    var periods: [String]  // Changed from a single string to an array of strings
    
    // Computed property to sort periods based on the predefined list
    var sortedPeriods: [String] {
        
        return periods.sorted {
            guard let index1 = periodsList.firstIndex(of: $0),
                  let index2 = periodsList.firstIndex(of: $1) else { return false }
            return index1 < index2
        }
    }
}

// Define the periods here
let periodsList = [
    "AM Registration", "Period 0", "Period 1", "Period 2", "Period 3", "Break",
    "Period 4", "Period 5", "Period 6a", "Period 6b", "PM Registration",
    "Period 7", "Period 8", "Period 9", "Period 10"
]

struct MultipleSelectionRow: View {
    var period: String
    var isSelected: Bool
    var toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            Text(period)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle()) // Makes the whole row tappable
        .onTapGesture {
            toggleSelection()
        }
        .padding(.horizontal)  // Optional: Add padding to the left and right of each row for better spacing
    }
}
