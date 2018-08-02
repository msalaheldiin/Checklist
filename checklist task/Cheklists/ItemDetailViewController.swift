//
//  ItemDetailViewController.swift
//  Cheklists
//  Copyright © 2018 Mahmoud. All rights reserved.

import UIKit
import UserNotifications
protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller:ItemDetailViewController)
    func itemDetailViewController(_controller:ItemDetailViewController,didFinishAdding item: ChecklistItem )
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem)
    
}

class ItemDetailViewController: UITableViewController ,UITextFieldDelegate{
    var itemToEdit: ChecklistItem?
    var duedate = Date()
    var datePickerVisible = false
    weak var delegate : ItemDetailViewControllerDelegate?
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var itemTF: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
 
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            itemTF.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            duedate = item.dueDate
        }
            updateDueDateLabel()
        datePicker.minimumDate = Date()
    }
    
    //MARK: Make focus on the textbox
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        itemTF.becomeFirstResponder()
    }
 
    @IBAction func cancel (){
        //dismiss(animated: true, completion: nil)
        delegate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    //MARK: Click Done
    //connected to textbox did end on exit event to close the screen back to the perrvious view
    @IBAction func done(){
        
        //dismiss(animated: true, completion: nil)
        //if edit
        if let item = itemToEdit {
            item.text = itemTF.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = duedate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
            //if new item
        else{
        let item = ChecklistItem()
        item.text = itemTF.text!
        item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = duedate
            item.scheduleNotification()
        delegate?.itemDetailViewController(_controller: self, didFinishAdding: item)
        }
        
    }
    
    //MARK: Prevent cell selection for any cell except dudate cell
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    //MARK: Disable done button if textfield is empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }

    //update date label from date time picker
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: duedate)
    }
    
    //Insert new cell into table view which contains the date time picker controller
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
       
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(duedate, animated: false)
    }
    
    //if the indexpath of datetime picker is pressed then it will return the date time picker controller
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        }
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
  
    }
    
    //return number of rows containig date time picker row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    //Specify the heghit of the date time picker cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
    }
    
    // End focus from textbox if the date time picker selected and hide,show according to which cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemTF.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        duedate = datePicker.date
        updateDueDateLabel()
    }
    //hide DatePicker
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    //ASk user for permission when switch vontrol on for the first time	
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        itemTF.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* do nothing */
            }
        } }
}
