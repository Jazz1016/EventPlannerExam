//
//  DateFormatter.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import Foundation

extension DateFormatter {
    
    static let eventTime: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
        
    }()
    
}//End of extension

extension Date {
    
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}//End of extension
