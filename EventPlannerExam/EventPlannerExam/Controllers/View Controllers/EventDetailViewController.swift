//
//  EventDetailViewController.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var createEditLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }
    
    // MARK: - Properties
    var event: Event?
    
    // MARK: - Actions
    
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        
        guard let name = eventNameTextField.text, !name.isEmpty else {return}
        
        if let event = event {
            event.eventName = name
            event.eventDate = datePicker.date
            EventController.shared.updateEventDetails(event)
        } else {
            EventController.shared.addEventWith(eventName: name, eventDate: datePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    func updateView() {
        guard let event = event else {return}
        eventNameTextField.text = event.eventName
        datePicker.date = event.eventDate ?? Date()
    }
}
