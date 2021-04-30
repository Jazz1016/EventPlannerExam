//
//  Event+Convenience.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//


import CoreData

extension Event {
    
    @discardableResult convenience init(eventName: String, eventDate: Date, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.eventName = eventName
        self.eventDate = eventDate
        self.uuid = UUID()
    }
    
    func didAttendEvent() -> Bool {
        guard let _ = (attendDates as? Set<AttendDate>)?.first(where: {
            attendDate in
            guard let day = attendDate.date else {return false}
            
            return Calendar.current.isDate(day, inSameDayAs: Date())
        })
        else {return false}
        
        return true
    }
    
}

