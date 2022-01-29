//
//  HomeViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift
import UserNotifications

protocol HomeDelegate{
    func reload()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var habitTableview: UITableView!
    
    var list = [Habit]()
    var realm : Realm?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realm = try! Realm()
        loadValues()
    }

    @IBAction func plusBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = self.storyboard!

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddHabit") as! AddViewController
        nextViewController.delegate = self
        self.show(nextViewController, sender: self)
    }
    
    func loadValues() {
        self.list = Array(try! Realm().objects(Habit.self))
        self.habitTableview.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitTableViewCell
        cell.habitLabel.text = "\(self.list[indexPath.row].habitt)"
//        cell.config(self.list[indexPath.row])
        return cell
    }
    //delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            try! realm?.write {
                realm?.delete(list[indexPath.row])
            }
            loadValues()
        } else if editingStyle == .insert {
        }
    }
}

extension HomeViewController: HomeDelegate {
    
    func reload() {
        loadValues()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoadd", let vc = segue.destination as? AddViewController{
            vc.delegate = self
        }
    }
}

