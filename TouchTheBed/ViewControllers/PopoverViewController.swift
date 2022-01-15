//
//  PopoverViewController.swift
//  TouchTheBed
//
//  Created by Helen Dun on 11/4/21.
//

import Cocoa

class PopoverViewController: NSViewController
{
    @IBOutlet weak var startHourField: NSTextField!
    @IBOutlet weak var startMinField: NSTextField!
    
    @IBOutlet weak var endHourField: NSTextField!
    @IBOutlet weak var endMinField: NSTextField!
    
    @IBOutlet weak var imageField: NSImageView!
    
    var timeRange: TimeRange? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guard let tr = timeRange else { return }
        startHourField.stringValue = stringifyTime(tr.startHour)
        startMinField.stringValue = stringifyTime(tr.startMin)
        endHourField.stringValue = stringifyTime(tr.endHour)
        endMinField.stringValue = stringifyTime(tr.endMin)
        
        tr.printTimeRange()
        
        if tr.isWithinTimeRange() {
            imageField.image = NSImage(named: "Moon")
        }
        else {
            imageField.image = NSImage(named: "Sun")
        }
    }
    
    override func viewDidDisappear()
    {
        super.viewDidDisappear()
        
        guard var tr = timeRange else { return }
        tr.startHour = startHourField.integerValue
        tr.startMin = startMinField.integerValue
        tr.endHour = endHourField.integerValue
        tr.endMin = endMinField.integerValue
        
        tr.printTimeRange()
    }
    
    static func newInstance(tr: TimeRange) -> PopoverViewController
    {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
          
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController
        else
        {
            fatalError("Unable to instantiate PopoverViewController in Main.storyboard")
        }
        viewcontroller.timeRange = tr
        return viewcontroller
    }
    
    func checkTime(_ sender: NSTextField, minimum: Int, maximum: Int)
    {
        var value = sender.integerValue
        if value > maximum
        {
            value = maximum
        }
        else if value < minimum
        {
            value = minimum
        }
        sender.stringValue = stringifyTime(value)
    }
    
    func stringifyTime(_ value: Int) -> String
    {
        var strvalue = String(value)
        if value < 10
        {
            strvalue = "0" +  strvalue
        }
        return strvalue
    }
    
    @IBAction func startHourAction(_ sender: NSTextField)
    {
        checkTime(sender, minimum: 0, maximum: 23)
    }
    @IBAction func startMinAction(_ sender: NSTextField)
    {
        checkTime(sender, minimum: 0, maximum: 59)
    }
    @IBAction func endHourAction(_ sender: NSTextField)
    {
        checkTime(sender, minimum: 0, maximum: 23)
    }
    @IBAction func endMinAction(_ sender: NSTextField)
    {
        checkTime(sender, minimum: 0, maximum: 59)
    }
}

