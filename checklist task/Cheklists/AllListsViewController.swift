//
//  AllListsViewController.swift
//  Cheklists
//  Copyright © 2018 Mahmoud. All rights reserved.

import UIKit

class AllListsViewController: UITableViewController,ListDetailViewControllerDelegate ,UINavigationControllerDelegate{
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate=self
       let index = dataModel.indexOfSelectedChecklist
        if  index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining"
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
       cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
        
        
    }
   
    func makeCell(for tableView: UITableView)->UITableViewCell{
        
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        }
        else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            
        }
        
    }
    
    //MARK: select item from tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Saving row index to user defalut to remember qhixh checklist is active
        
         UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
         dataModel.indexOfSelectedChecklist = indexPath.row
        let checkList = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checkList)
    }
    
    //MARL: send checklist name in the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="ShowChecklist" {
            
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            
        }
        else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination  as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
        
        
    }
    
    //Deleting rows from datamodel and the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,  didFinishAdding checklist: Checklist) {

        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,  didFinishEditing checklist: Checklist) {

        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
        
    }
    //navigate to the Edit Checklist screen
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier : "ListDetailNavigationController") as! UINavigationController
        let controller =  navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checkList = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checkList
        present(navigationController, animated: true, completion: nil)
        
    }
    //To recognize whether the user presses the back button on the navigation bar
    //This method is called whenever the navigation controller will slide to a new screen.

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1 
        }
    }
    
  
}
