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
        
        let fileManager = NSFileManager.defaultManager()
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(documentsPath)!
        while let fileName = enumerator.nextObject() as? String {
            var path = documentsPath.stringByAppendingPathComponent(fileName)
            let body = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            
            var script = Script()
            script.title = fileName.stringByDeletingPathExtension
            script.body = body!
            scripts.append(script)
          //  fileManager.removeItemAtPath(documentsPath.stringByAppendingPathComponent(fileName), error: nil)
      

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