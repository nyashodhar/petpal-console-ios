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

        let bundle = NSBundle.mainBundle()
        let examples = bundle.pathsForResourcesOfType("basic", inDirectory: nil)
        
        for fileName in examples as [NSString] {
            let newFile = documentsPath.stringByAppendingPathComponent(fileName.lastPathComponent);
            let markerFile = documentsPath.stringByAppendingPathComponent("." + fileName.lastPathComponent);
            if ( !fileManager.fileExistsAtPath(newFile) && !fileManager.fileExistsAtPath(markerFile)) {
                var body = String(contentsOfFile: fileName, encoding: NSUTF8StringEncoding, error: nil)!
                body.writeToFile(newFile, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
            }
        }

        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(documentsPath)!
        while let fileName = enumerator.nextObject() as? String {
            if ( !fileName.stringByDeletingPathExtension.hasPrefix(".")) {
                var path = documentsPath.stringByAppendingPathComponent(fileName)
                let body = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
                
                var script = Script()
                script.title = fileName.stringByDeletingPathExtension
                script.body = body!
                script.fileName = fileName
                scripts.append(script)
            }
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
        cell.textLabel?.text = scripts[indexPath.row].getTitle()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete ) {
            var fileName = scripts[indexPath.row].fileName
            
            let bundle = NSBundle.mainBundle()
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            // create an file to show that the example is deleted
            if let example = bundle.pathForResource(fileName.lastPathComponent.stringByDeletingPathExtension, ofType: "basic", inDirectory: nil) {
                let markerFile = documentsPath.stringByAppendingPathComponent("." +  fileName.lastPathComponent)
                scripts[indexPath.row].body.writeToFile(markerFile, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
            }
            
            let fileManager = NSFileManager.defaultManager()
            fileManager.removeItemAtPath(documentsPath.stringByAppendingPathComponent(fileName), error: nil)
            scripts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (selectedScript != nil) {
            if let scriptViewController = segue.destinationViewController as? ScriptEditViewController {
                scriptViewController.script = selectedScript
            }
        }
    }
    
}