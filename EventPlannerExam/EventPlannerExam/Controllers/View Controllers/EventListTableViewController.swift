//
//  EventListTableViewController.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import UIKit

class EventListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        EventController.shared.fetchAllEvents()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventController.shared.fetchAllEvents()
        
        tableView.reloadData()
    }
    
//    var event: Event
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return EventController.shared.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {return UITableViewCell()}
        
        let event = EventController.shared.sections[indexPath.section][indexPath.row]
        
        cell.delegate = self
        
        cell.configure(with: event)
        
        return cell
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = EventController.shared.sections[indexPath.section][indexPath.row]
            EventController.shared.deleteEvent(event: event)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Events"
        } else if section == 1 {
            return "Attended"
        }
        return nil
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEventDetailVC" {
            guard let destinationVC = segue.destination as? EventDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let event = EventController.shared.sections[indexPath.section][indexPath.row]
            
            destinationVC.event = event
        }
        
        
    }
}

extension EventListTableViewController: EventCellDelegate {
    
    func attendedWasTappped(didAttend: Bool, event: Event, cell: EventTableViewCell) {
        EventController.shared.updateEvent(didAttend, event: event)
        tableView.reloadData()
    }
}

// JAMLEA: BUILD DELEGATE EXTENSION
