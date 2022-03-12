//
//  HomeViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift
import SwiftyTimer

protocol HomeDelegate{
    func reload()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var noFilterView: UIView!
    @IBOutlet weak var dropDownButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var habitTableView: UITableView!
    
    var delegate: AddHabitDelegate?
    var habitList = [Habit]()
    var realm : Realm?
    var transparentView = UIView()
    var dropDownTableView = UITableView()
    var settingArray = ["Add New Habit","Edit Habit List","Logout"]
    let height: CGFloat = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realm = try! Realm()
        
        nameLabel.text = "\(UserDefaults.standard.string(forKey: "name") ?? "")"
        
        dropDownTableView.isScrollEnabled = true
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "dropDownCell")
        dropDownTableView.layer.cornerRadius = 11.25
        
        doneButton.isHidden = true
        
        loadValues()
        timer()
        emptyView()
        
        switch traitCollection.userInterfaceStyle {
        case .dark: doneButton.tintColor = UIColor.white
            dropDownButton.setTitle("Menu", for: .normal)
            dropDownButton.tintColor = UIColor.white
            self.dropDownButtonTopConstraint.constant = 74
            break
        case .light: doneButton.tintColor = UIColor.black
            dropDownButton.setImage(UIImage(named: "MenuIcon.light"), for: .normal)
            self.dropDownButtonTopConstraint.constant = 60
            break
        default:
            print("Something else")
        }
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        dropDownTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(dropDownTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.dropDownTableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.habitTableView.isEditing = !self.habitTableView.isEditing
        if habitList.isEmpty == false && habitTableView.isEditing == true {
            doneButton.isHidden = false
            dropDownButton.isHidden = true
        }else{
            doneButton.isHidden = true
            dropDownButton.isHidden = false
        }
    }
    
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.dropDownTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadValues() {
        self.habitList = Array(try! Realm().objects(Habit.self))
        self.habitTableView.reloadData()
    }
    
    func timer() {
        Timer.every(5.seconds) { (timer: Timer) in
            self.habitTableView.reloadData()
            self.nameLabel.text = "Apple"
            }
    }
    
    func emptyView(){
        self.habitTableView.reloadData()
        if self.habitList.count == 0 {
            self.noFilterView.isHidden = false
        } else{
            self.noFilterView.isHidden = true
        }
    }
}

extension HomeViewController: HomeDelegate {
    func reload() {
        loadValues()
        emptyView()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case habitTableView:
            numberOfRow = habitList.count
        case dropDownTableView:
            numberOfRow = settingArray.count
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch tableView {
        case habitTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitTableViewCell
            cell.config(self.habitList[indexPath.row])
            return cell
        case dropDownTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDownCell", for: indexPath as IndexPath) as? DropDownTableViewCell
            cell!.lbl.text = settingArray[indexPath.row]
            cell!.selectionStyle = .none
            cell!.settingImage.image = UIImage(named: settingArray[indexPath.row])!
            return cell!
        default:
            print("Some things Wrong!!")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == habitTableView{
            let moveObjTemp = habitList[sourceIndexPath.item]
            habitList.remove(at: sourceIndexPath.item)
            habitList.insert(moveObjTemp, at: destinationIndexPath.item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropDownTableView{
            onClickTransparentView()
            switch indexPath.row {
            case 0:
                let storyBoard : UIStoryboard = self.storyboard!
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddHabit") as! AddHabitViewController
                nextViewController.delegate = self
                self.present(nextViewController, animated: true, completion: nil)
            case 1:
                if habitList.isEmpty == true && habitTableView.isEditing == false {
                    dropDownButton.isHidden = false
                    doneButton.isHidden = true
                    let alertController = UIAlertController(title: "Oops, the habit list is empty.", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else{
                    self.habitTableView.isEditing = !self.habitTableView.isEditing
                    dropDownButton.isHidden = true
                    doneButton.isHidden = false
                }
            case 2:
                UserDefaults.standard.set(false, forKey: "isLogin")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.show(vc!, sender: nil)
            default:
                print("Unable to create viewcontroller")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView == dropDownTableView{
            return 50
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if tableView == habitTableView{
            let habit = self.habitList[indexPath.row]
            let deleteAction = UIContextualAction(style: .destructive , title:  "") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
                
                let alert = UIAlertController(title: "Delete Habit", message: "Are you sure you want to delete this habit: \(habit.title)?", preferredStyle: .alert)
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
                    self.emptyView()
                }))
                self.present(alert, animated: true)
            }
            deleteAction.image = UIImage(named: "DeleteIcon")
            
            let editAction = UIContextualAction(style: .normal, title: "") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
                actionPerformed(true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditHabit") as? EditHabitViewController
                vc?.habit = self.habitList[indexPath.row]
                vc!.delegate = self
                self.present(vc!, animated: true, completion: nil)
            }
            editAction.image = UIImage(named: "EditIcon")
            editAction.backgroundColor = UIColor(named: "EditColor")
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        return UISwipeActionsConfiguration()
    }
}
