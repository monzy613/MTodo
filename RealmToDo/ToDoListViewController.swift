//
//  ToDoListViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import LocalAuthentication

class ToDoListViewController: UITableViewController {
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var isAuthenticationSuccess = false
    
    //Mark dataSource
    var list = [Note]()
    var initList = [Note]()
    var currentNote = Note()
    
    //Mark tool functions
    private func reloadNoteList() {
        initList.removeAll()
        list.removeAll()
        for note in uiRealm.objects(Note).sorted("createdAt") {
            self.initList.append(note)
            self.list.append(note)
        }
        if isAuthenticationSuccess == false {
            self.list = []
        } else {
            self.list = initList
            self.tableView.reloadData()
        }
    }
    
    
    func setAuthentication() {
        if isAuthenticationSuccess == true {
            stopRefreshing()
            return
        }
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey("AuthenticationSwitch") == nil {
            userDefault.setBool(false, forKey: "AuthenticationSwitch")
            print("AuthenticationSwitch set")
            isAuthenticationSuccess = true
        } else {
            if userDefault.boolForKey("AuthenticationSwitch") == true {
                isAuthenticationSuccess = false
                AuthenticationSetter.touchIdAuthentication(){
                    isSuccess, error in
                    if isSuccess {
                        print("touchId authentication success")
                        self.isAuthenticationSuccess = true
                        self.list = self.initList
                        dispatch_async(dispatch_get_main_queue()) {
                            MZToastView().configure((self.revealViewController().view)!, content: "success", position: .Middle, length: .Short, lightMode: .Dark).show()
                            self.tableView.reloadData()
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            switch error as! LAError {
                            case .UserCancel:
                                print("User Cancel")
                                break
                            case .SystemCancel:
                                print("Systen cancel the touchId authentication")
                                break
                            case .AuthenticationFailed:
                                MZToastView().configure((self.revealViewController().view)!, content: "Wrong finderprint", position: .Middle, length: .Short, lightMode: .Dark).show()
                                break
                            case .UserFallback, .TouchIDNotAvailable, .TouchIDNotEnrolled:
                                AuthenticationSetter.showPasswordAlert(self,
                                    onSuccess: {
                                        MZToastView().configure((self.revealViewController().view)!, content: "success", position: .Middle, length: .Short, lightMode: .Dark).show()
                                        self.isAuthenticationSuccess = true
                                        self.list = self.initList
                                        self.tableView.reloadData()
                                    },
                                    onFail: {
                                        MZToastView().configure((self.revealViewController().view)!, content: "Wrong password", position: .Middle, length: .Short, lightMode: .Dark).show()
                                    }
                                )
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                isAuthenticationSuccess = true
                reloadNoteList()
            }
        }
        stopRefreshing()
    }
    
    private func stopRefreshing() {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    //Mark actions
    @IBAction func addItem(sender: UIBarButtonItem) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "setAuthentication", forControlEvents: .ValueChanged)
        setAuthentication()
        print(NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)[0])
    }

    
    override func viewWillAppear(animated: Bool) {
        reloadNoteList()
    }
    
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
        initSideMenu()
    }
    
    func initSideMenu() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            self.revealViewController().rearViewRevealWidth = self.view.frame.width / 2
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let index = list.count - indexPath.row - 1
        let title = list[index].title
        if title == "" {
            cell.textLabel?.text = "no title"
        } else {
            cell.textLabel?.text = title
        }
        cell.detailTextLabel!.text = "\(DateTool.dateStringWithNSDate(list[index].createdAt))"
        
        /*
        let content = list[index].content
        if content == "" {
            cell.detailTextLabel!.text = "no content"
        } else {
            cell.detailTextLabel!.text = content
        }
        */
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = list.count - indexPath.row - 1
        currentNote = list[index]
        performSegueWithIdentifier("ShowNoteSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "ShowNoteSegue":
                    let destViewController = segue.destinationViewController as! ShowViewController
                    destViewController.note = currentNote
                break
            default: break
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            do {
                try uiRealm.write() {
                    let index = self.list.count - indexPath.row - 1
                    uiRealm.delete(self.list[index])
                    self.list.removeAtIndex(index)
                }
            }
            catch {
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            stopRefreshing()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
