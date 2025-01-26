import SwiftUI

class EventStatusService {
    // Determine the event's status view based on due date
    static func eventStatus(for dueDate: Date) -> some View {
        let currentDate = Date()
        let calendar = Calendar.current

        // Check if the event is today, in the past, or in the future
        if calendar.isDateInToday(dueDate) {
            return Image(systemName: "calendar.and.person")
                .renderingMode(.template)
                .foregroundColor(.green)
        } else if dueDate > currentDate {
            return Image(systemName: "calendar.badge.clock")
                .renderingMode(.template)
                .foregroundColor(.blue)
        } else {
            return Image(systemName: "calendar.badge.exclamationmark")
                .renderingMode(.template)
                .foregroundColor(.red)
        }
    }
}
