//
//  HomeViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift

protocol HomeDelegate{
    func reload()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var editLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var habitList = [Habit]()
    var realm : Realm?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realm = try! Realm()
        loadValues()
        nameLabel.text = "\(UserDefaults.standard.string(forKey: "name") ?? "")"
    }

    @IBAction func editCellButton(_ sender: Any) {
        self.habitTableView.isEditing = !self.habitTableView.isEditing
        if habitTableView.isEditing == true {
            editLabel.setTitle("Done", for: .normal)
        }else{
            editLabel.setTitle("Edit List", for: .normal)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = self.storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddHabit") as! AddViewController
        nextViewController.delegate = self
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func loadValues() {
        self.habitList = Array(try! Realm().objects(Habit.self))
        self.habitTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habitList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitTableViewCell
        cell.config(self.habitList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObjTemp = habitList[sourceIndexPath.item]
        habitList.remove(at: sourceIndexPath.item)
        habitList.insert(moveObjTemp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let habit = self.habitList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive , title:  "") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let alert = UIAlertController(title: "Delete Habit", message: "Are you sure you want to delete this habit: \(habit.habitTitle)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {  (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alertAction) in
                try! self.realm?.write {
                    self.realm?.delete(self.habitList[indexPath.row])
                }
                self.habitList = Array(try! Realm().objects(Habit.self))
                self.habitTableView.deleteRows(at: [indexPath], with: .fade)
                actionPerformed(true)
            }))
            self.present(alert, animated: true)
        }
        deleteAction.image = UIImage(named: "DeleteIcon")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "") { (contextualAction, view, actionPerformed: (Bool) -> ()) in

            actionPerformed(true)
        }
        editAction.image = UIImage(named: "EditIcon")
        editAction.backgroundColor = UIColor(named: "EditColor")
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

extension HomeViewController: HomeDelegate {
    func reload() {
        loadValues()
    }
}
