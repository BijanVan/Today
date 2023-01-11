//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Bijan Nazem on 2023-01-11.
//

import Foundation
import EventKit

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        
        id = UUID(uuidString: ekReminder.calendarItemIdentifier)!
        title = ekReminder.title
        self.due = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
