//
//  EventController.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//
//
//  EventController.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//
import CoreData

class EventController {
    // MARK: - SHAREDINSTANCE AND SOT
    static let shared = EventController()
    let notificationScheduler = NotificationScheduler()
    
    var sections: [[Event]] {[eventsToAttend, eventsAttended]}
    var eventsToAttend: [Event] = []
    var eventsAttended: [Event] = []
    
    private lazy var fetchRequest: NSFetchRequest<Event> = {
        let request = NSFetchRequest<Event>(entityName: "Event")
        request.predicate = NSPredicate(value: true)
        
        return request
    }()
    
    private init() {}

    
    // MARK: - CRUD
    
    func addEventWith(eventName: String, eventDate: Date){
        let event = Event(eventName: eventName, eventDate: eventDate)
        eventsToAttend.append(event)
        
        CoreDataStack.saveContext()
        
        notificationScheduler.scheduleNotifications(for: event)
    }
    
    func fetchAllEvents() {
        let coreEvents = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        
        eventsAttended = coreEvents.filter { $0.didAttendEvent() }
        eventsToAttend = coreEvents.filter { !$0.didAttendEvent() }
        
    }
    
    func updateEvent(_ didAttend: Bool, event: Event){
        
        if didAttend {
            AttendDate(date: Date(), event: event)
            if let index = eventsToAttend.firstIndex(of: event) {
                eventsToAttend.remove(at: index)
                eventsAttended.append(event)
            }
            notificationScheduler.clearNotifications(for: event)
            CoreDataStack.saveContext()
        } else {
            let mutableAttendDates = event.mutableSetValue(forKey: "attendDates")
            
            if let attendDate = (mutableAttendDates as? Set<AttendDate>)?.first(where: { attendDate in
                guard let date = attendDate.date else {return false}
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableAttendDates.remove(attendDate)
                if let index = eventsAttended.firstIndex(of: event) {
                    eventsAttended.remove(at: index)
                    eventsToAttend.append(event)
                    notificationScheduler.scheduleNotifications(for: event)
                }
            }
        }
        CoreDataStack.saveContext()
    }
    
    func updateEventDetails(_ event: Event){
        if !event.didAttendEvent() {
            notificationScheduler.scheduleNotifications(for: event)
        }
        CoreDataStack.saveContext()
    }
    
    
    func markEventAsAttended(WithUUID uuid: String) {
        guard let uuid = UUID(uuidString: uuid),
              let event = eventsToAttend.first(where: { $0.uuid == uuid })
        else {return}
        
        AttendDate(date: Date(), event: event)
        CoreDataStack.saveContext()
    }
    
    
    func deleteEvent(event: Event){
        
        if let index = eventsToAttend.firstIndex(of: event){
            eventsToAttend.remove(at: index)
        } else if let index = eventsAttended.firstIndex(of: event) {
            eventsAttended.remove(at: index)
        }
        CoreDataStack.context.delete(event)
        notificationScheduler.clearNotifications(for: event)
        CoreDataStack.saveContext()
    }
}
