//
//  EventTableViewCell.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import UIKit

// MARK: - Protocol

protocol EventCellDelegate: AnyObject {
    func attendedWasTappped(didAttend: Bool, event: Event, cell: EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var eventNameTextLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventAttendButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: EventCellDelegate?
    var event: Event?
    private var didAttendToday: Bool = false
    
    // MARK: - Actions
    @IBAction func eventButtonTapped(_ sender: Any) {
        
        guard let event = event else {return}
        
        didAttendToday.toggle()
        
        delegate?.attendedWasTappped(didAttend: didAttendToday, event: event, cell: self)
    }
    
    
    
    // MARK: - Function
    func configure(with event: Event){
        self.event = event
        didAttendToday = event.didAttendEvent()
        
        eventNameTextLabel.text = event.eventName
        
        eventDateLabel.text = DateFormatter.eventTime.string(from: event.eventDate ?? Date())
        
        let image = didAttendToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        eventAttendButton.setImage(image, for: .normal)
        eventAttendButton.tintColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        event = nil
        didAttendToday = false
    }
    
    
}//End of class
