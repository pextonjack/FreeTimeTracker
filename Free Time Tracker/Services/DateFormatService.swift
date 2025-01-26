import Foundation

// A service responsible for date formatting
class DateFormatService {
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "EEE, MMM d, yyyy" // Show the day of the week
        return formatter.string(from: date)
    }
}
