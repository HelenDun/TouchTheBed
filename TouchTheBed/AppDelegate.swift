//
//  AppDelegate.swift
//  TouchTheBed
//
//  Created by Helen Dun on 11/4/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate
{
    let popupWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PopupWindowController") as! NSWindowController
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    
    var timeRange = TimeRange()
    let bedtimeTimer = BedtimeTimer()
    let daynightTimer = DayNightTimer()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Creates menu bar icon
        if let button = self.statusItem.button
        {
            button.image = NSImage(named: NSImage.Name("Sleep"))
            button.action = #selector(AppDelegate.togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = PopoverViewController.newInstance(tr: timeRange)
        popover.animates = false
        
        // Monitors if the user clicks anywhere not on the popover
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
        {
            [weak self] event in
            if let strongSelf = self {
                if strongSelf.popover.isShown {
                    strongSelf.closePopover(sender: event)
                }
            }
        }
        
        bedtimeTimer.delegate = self
        daynightTimer.bedtimeTimer = bedtimeTimer
        daynightTimer.timeRange = timeRange
    }

    @objc func togglePopover(_ sender: NSStatusItem)
    {
        if self.popover.isShown
        {
            closePopover(sender: sender)
        }
        else
        {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?)
    {
        if let button = self.statusItem.button
        {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?)
    {
        self.popover.performClose(sender)
        self.eventMonitor?.stop()
    }
}

// become bedtime timer
extension AppDelegate: BedtimeTimerProtocol {
    func timerHasFinished(_ timer: BedtimeTimer)
    {
        NSApp.activate(ignoringOtherApps: true)
        popupWindowController.loadWindow()
        popupWindowController.window?.makeKeyAndOrderFront(self)
        timer.resetTimer()
        timer.startTimer()
    }
}
