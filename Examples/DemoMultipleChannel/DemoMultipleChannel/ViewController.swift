//
//  ViewController.swift
//  DemoMultipleChannel
//
//  Created by Jeremy Labrado on 26/05/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableViewAvailable: UITableView!
    @IBOutlet weak var myTableViewConnected: UITableView!
    
    var stretchsenseObject = StretchSenseAPI()

////////
    override func viewDidLoad() {
        print("viewDidLoad()")
        /* This function is called as the initialiser of the view controller */
        super.viewDidLoad()
        
        // Start scanning for new peripheral
        stretchsenseObject.startBluetooth()
        
        // initialazing the table view
        self.myTableViewAvailable.delegate = self
        self.myTableViewAvailable.dataSource = self
        // initialazing the table view
        self.myTableViewConnected.delegate = self
        self.myTableViewConnected.dataSource = self
        // Load data
        myTableViewAvailable.reloadData()
        myTableViewConnected.reloadData()
        
        // setting the observer waiting for notification
        let defaultCenter = NSNotificationCenter.defaultCenter()
        // when a notification "UpdateInfo" is detected, go to the function newInfoDetected()
        defaultCenter.addObserver(self, selector: #selector(newInfoDetected), name: "UpdateInfo",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification0",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification1",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification2",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification3",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification4",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification5",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification6",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification7",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification8",object: nil)
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: "UpdateValueNotification9",object: nil)



        
        //NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(update), userInfo: nil, repeats: false)
        stretchsenseObject.startScanning()

    }
    
    // MARK: New Info Functions
    
    func newInfoDetected() {
        print("newInfoDetected()")
        // if a notification is received, reload the tables
        myTableViewAvailable.reloadData()
        myTableViewConnected.reloadData()
        stretchsenseObject.startScanning()

    }
    
    func newValueDetected0() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected1() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected2() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected3() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected4() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected5() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected6() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected7() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected8() {
        myTableViewConnected.reloadData()
    }
    func newValueDetected9() {
        myTableViewConnected.reloadData()
    }
    
    
    /*func update() {
        print("update()")
        myTableViewAvailable.reloadData()
        myTableViewConnected.reloadData()

    }*/
    
    
    // MARK:  TableView Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        if tableView == self.myTableViewAvailable {
            print("numberOfRowInSection() Available")

            // Set the number of Rows in the Table
            return stretchsenseObject.getNumberOfPeripheralAvailable()
        }
        else {
            print("numberOfRowInSection() Connected")

            return stretchsenseObject.getNumberOfPeripheralConnected()
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView()")
        // Set the number of Section in the table
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath()")
        // This function filled each cell with the UUID and set the background color depending on the sensors's state
        
        
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        let listperipheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if tableView == self.myTableViewAvailable {
            print("cellForRowAtIndexPath() Available")

            let cellAvailable = tableView.dequeueReusableCellWithIdentifier("CellAvailable", forIndexPath: indexPath) as UITableViewCell

            if listPeripheralsAvailable.count != 0 {
                // If the sensor is connected, the background is green and we display his color in the subtitle
                if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Connected{
                    cellAvailable.backgroundColor = UIColor.greenColor()
                    for myPeripheralConnected in listperipheralsConnected{
                        if myPeripheralConnected.uuid == (cellAvailable.textLabel?.text)!{
                            //cell.detailTextLabel?.text = myPeripheralConnected.colorName[myPeripheralConnected.uniqueNumber]
                            cellAvailable.detailTextLabel?.text = myPeripheralConnected.colors[myPeripheralConnected.uniqueNumber].colorName
                        }
                        else{
                        }
                    }
                }
                // If the sensor is disconnected, the background is grey
                else if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Disconnected{
                    cellAvailable.backgroundColor = UIColor.lightGrayColor()
                }
            }
            // For each row, we complete it with the UUID of the sensor
            cellAvailable.textLabel?.text = "\(listPeripheralsAvailable[indexPath.row]!.identifier.UUIDString)"
            return cellAvailable
        }
        
        else {
            print("cellForRowAtIndexPath() Connected")

            let cellConnected = tableView.dequeueReusableCellWithIdentifier("CellConnected", forIndexPath: indexPath) as UITableViewCell

            for myPeripheralConnected in listperipheralsConnected{
                cellConnected.textLabel?.text = String(myPeripheralConnected.value)
                cellConnected.textLabel?.text = String(format: "%.1f", myPeripheralConnected.value) + " pF"
                
                cellConnected.backgroundColor = myPeripheralConnected.colors[indexPath.row].colorValueRGB
                cellConnected.detailTextLabel?.text = myPeripheralConnected.uuid
            }
            return cellConnected
            }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath()")
        // This function is called when we click on one cell
        // We want to connect or disconnect the sensor clicked
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        
        // If the sensor is connected we want to disconnect it by asking the confirmation
        if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Connected{
            let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to disconnect the peripheral? ", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                // If we confirm, we disconnect this sensor
                self.stretchsenseObject.disconnectOnePeripheralWithUUID(cell!.textLabel!.text!)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                // Else we let the sensor connected
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
            
            // If the sensor is disconnected, we connect it
        else if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Disconnected{
            if indexPath.row <= listPeripheralsAvailable.count{
                //print("Go to connect Function")
                stretchsenseObject.connectToPeripheralWithUUID(cell!.textLabel!.text!)
            }
        }
    }

    
    /////////


}

