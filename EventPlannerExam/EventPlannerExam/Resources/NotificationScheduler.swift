//
//  NotificationScheduler.swift
//  EventPlannerExam
//
//  Created by James Lea on 5/1/21.
//

import UserNotifications

class NotificationScheduler {
    
    func scheduleNotifications(for event: Event) {
        
        guard let eventName = event.eventName,
              var eventDate = event.eventDate,
              let uuid = event.uuid?.uuidString
                else {return}
        
        clearNotifications(for: event)
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.sound = .default
        content.body = "\(eventName) starts in 5 minutes!"
        content.userInfo = [Strings.eventID : event.uuid?.uuidString ?? "event"]
        content.categoryIdentifier = Strings.eventCategoryIdentifier
        content.badge = 1
        
        eventDate.addTimeInterval(-300)
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: eventDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request\nError in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func clearNotifications(for event: Event) {
        
        guard let identifier = event.uuid?.uuidString else {return}
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
