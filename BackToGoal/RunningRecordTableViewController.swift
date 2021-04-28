//
//  RunningRecordTableViewController.swift
//  BackToGoal
//
//  Created by Apurva Bhoite on 4/26/21.
//

import UIKit
import CoreData
import CoreLocation

class RunningRecordTableViewCell: UITableViewCell{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTimeTaken: UILabel!
}

class RunningRecordTableViewController: UITableViewController {

    var records:[NSManagedObject] = []
    
    var manageObjectContext = NSManagedObjectContext?.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecords()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }
    
    func fetchRecords(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RunningRecord")
        do{
            records = try managedContext.fetch(fetchRequest)
            
        }catch let error as NSError{
            print("Could not fetch \(error)  \(error.userInfo)")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RunningRecordTableViewCell
        let record = records[indexPath.row] as! RunningRecord
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        cell.lblDate.text = dateFormatter.string(from: record.date!)
        cell.lblDistance.text = String(format: "%.2f KM", record.distanceTravelled)
        cell.lblTimeTaken.text = timeToString(time: Int(record.timeTaken))
        // Configure the cell...
        return cell
    }
    
    // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
    //             Delete the row from the data source
                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
                context.delete(records[indexPath.row])
                records.remove(at: indexPath.row)
                try? context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
  
        }

    func timeToString(time:Int) -> String {
        let hours = time / 3600
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewRecord"{
            let destination = segue.destination as! RunningRecordViewController
            let record = records[(tableView.indexPathForSelectedRow?.row)!] as! RunningRecord

            destination.date = record.date
            destination.timeTaken = Int(record.timeTaken)
            destination.distanceTravelled = record.distanceTravelled
            destination.pace = Int(record.pace)

            let coordinatePoints = record.coordinates?.allObjects as! [Coordinate]
            destination.coordinates = [] //clear coordinate list
            for point in coordinatePoints{
                destination.coordinates.append(CLLocationCoordinate2DMake(point.latitude, point.longitude))
            }
        }
    }

}
