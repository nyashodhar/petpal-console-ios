//
//  ScriptListViewController.swift
//  PetPal Console
//
//  Created by Haavar Valeur on 11/24/14.
//  Copyright (c) 2014 Haavar Valeur. All rights reserved.
//

import UIKit

class ScriptListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var scripts = [Script]()
    var selectedScript: Script?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        if (scripts.isEmpty) {
            var script = Script()
            script.title = "Hello world"
            script.body = "10 PRINT \"Hello world\""
            scripts.append(script)
            println("creating script")
        }
    }
    
    @IBAction func newClicked(sender: UIButton) {
        selectedScript = Script()
        scripts.append(selectedScript!)
        self.performSegueWithIdentifier("edit", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedScript = scripts[indexPath.item]
        self.performSegueWithIdentifier("edit", sender: self)

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("script_cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = scripts[indexPath.row].getTitle()
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (selectedScript != nil) {
            if let scriptViewController = segue.destinationViewController as? ScriptEditViewController {
                scriptViewController.script = selectedScript
            }
        }
    }
    
}