//
//  eventDate.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import CoreData

extension AttendDate{
    @discardableResult convenience init(date: Date, event: Event, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        self.date = date
        self.event = event
    }
}
