//
//  HomeViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift
//import SwiftyTimer

protocol HomeDelegate{
    func reload()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var noFilterView: UIView!
    @IBOutlet weak var habitTableView: UITableView!
    
    //    var delegate: AddHabitDelegate?
    var habitList = [Habit]()
    var realm : Realm?
    var transparentView = UIView()
    var dropDownTableView = UITableView()
    var settingArray = ["Add New Habit","Edit Habit List","Rename"]
    let dropDownTableViewHeight: CGFloat = 180
    var timerDarkMode = Timer()
    var timerReloadTableView = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hanleView()
    }
    
    func hanleView() {
        
        self.realm = try! Realm()
        
        dropDownTableView.isScrollEnabled = true
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "dropDownCell")
        dropDownTableView.layer.cornerRadius = 11.25
        
        dropDownButton.setTitle("", for: .normal)
        doneButton.isHidden = true
        doneButton.titleLabel?.font = UIFont(name: "RooneySans-Bold", size: 17)
        doneButton.titleLabel?.font = doneButton.titleLabel?.font.withSize(17)
        
        loadValues()
        emptyView()
        handleDarkMode()
        reloadTableViewTimer()
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        dropDownTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: dropDownTableViewHeight)
        window?.addSubview(dropDownTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.dropDownTableView.frame = CGRect(x: 0, y: screenSize.height - self.dropDownTableViewHeight, width: screenSize.width, height: self.dropDownTableViewHeight)
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
            self.dropDownTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.dropDownTableViewHeight)
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadValues() {
        self.habitList = Array(try! Realm().objects(Habit.self))
        self.habitTableView.reloadData()
    }
    
    func reloadTableViewTimer() {
        self.timerReloadTableView = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            self.habitTableView.reloadData()
        })
    }
        
    func emptyView(){
        self.habitTableView.reloadData()
        if self.habitList.count == 0 {
            self.noFilterView.isHidden = false
        } else{
            self.noFilterView.isHidden = true
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        handleDarkMode()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        handleDarkMode()
    }
    
    func handleDarkMode() {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            dropDownButton.setImage(UIImage(named: "MenuIconWhite"), for: .normal)
        } else {
            dropDownButton.setImage(UIImage(named: "MenuIconBlack"), for: .normal)
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
            
            cell.habitCellButton.tag = indexPath.row
            cell.habitCellButton.setTitle("", for: .normal)
            cell.habitCellButton.addTarget(self, action: #selector(editPageButtonTapped), for: .touchUpInside)
            
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
    
    @objc func editPageButtonTapped(_ sender: UIButton) {
        let storyBoard : UIStoryboard = self.storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditHabit") as! EditHabitViewController
        nextViewController.delegate = self
        self.present(nextViewController, animated: true, completion: nil)
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetName")
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
        return 100
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
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return UISwipeActionsConfiguration()
    }
}

//delete UI, angizeshi jomle, tableViewScroll, update func, all device size
