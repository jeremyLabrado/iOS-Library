/**
 - note: StretchSenseLibrary.swift
 
 - Important: This StretchSense library has been designed to enable the connection of one or more StretchSense Fabric Evaluation Sensor to your iOS application
 http://stretchsense.com/evaluation-kits/fabric-stretch-sensor-evaluation-kit/
 
 - Author: StretchSense
 
 - Copyright:  2016 StretchSense
 
 - Date: 1/06/2016
 
 - Version:    1.0.0
 
  **Definitions:**
 - **Peripheral**: Bluetooth 4.0 enabled sensors
 - **Manager**: Bluetooth 4.0 enabled iOS device
 - **FIR**: Finite Impulse Response
 - **IIR**: Infinite Impulse Response
 
 */


import UIKit
import Foundation
import CoreBluetooth // To use the bluetooth
import MessageUI 	 // To use the email

/*-------------------------------------------------------------------------------*/
// MARK: - CLASS STRETCHSENSEPERIPHERAL

/**
 This class defines a single Fabric Evaluation StretchSense sensor
 
 - note: Each sensor is defined by:
 - A universal unique identifier UUID
 - A unique number, based on the order when the sensor is connected
 - A unique color, choose with his unique number
 - A current capacitance value
 - An array of the 50 previous capacitance raw values
 - An array of the 50 previous capacitance averaged values
 
 
 ```swift
 // Example: Display the sensors connected in a table
 
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Determine the total number of sensors connected (i.e. total number of elements within a table)
    return stretchsenseObject.getNumberOfPeripheralConnected()
 }
 
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // This function is called to populate each row in the table
    // The row number of the table is define with his indexPath.row
 
    // The current cell
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    // The current peripheral
    let myPeripheral = listPeripheralsConnected[indexPath.row]
 
    // display the title: capactiance value of the sensor
    cell.textLabel?.text = myPeripheralConnected.value
    // display the subtitle: identifier color (text) of the sensor
    cell.detailTextLabel?.text = myPeripheral.colors[myPeripheral.uniqueNumber].colorName
    // change the background color of the cell: indentifier color of the sensor
    cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].valueRGB
 }
 
 */
class StretchSensePeripheral{
    
    // MARK: VARIABLES
    
    /// Universal Unique IDentifier
    var uuid = "";
    /// Current capacitance value of the sensor
    var value = CGFloat();
    /// A unique number for each sensor, based on the order when the sensor is connected
    var uniqueNumber = 0;
    /// The 50 previous samples averaged
    var previousValueAveraged = [CGFloat](count: 50, repeatedValue:0)
    /// The 50 previous samples raw
    var previousValueRawFromTheSensor = [CGFloat](count: 50, repeatedValue:0)
    
    /// Structure of Color: (name: String, valueRGB: UIColor)
    struct Color {
        /// The color name (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
        var colorName: String = "colorName"
        /// The value (RGB) of the color (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
        var colorValueRGB: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)
    }
    
    /// Array of color already implemented (Blue, Orange, Green, Red, Purple, Brown,
    /// Advice: use the variable uniqueNumber as reference of this array to have a unique color for each sensor
    var colors : [Color] = [
        Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
        Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
        Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
        Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
    ]
}



/*-------------------------------------------------------------------------------*/
// MARK: - CLASS STRETCHSENSEAPI


/**
 ## StretchSenseAPI ##
 
 The StretchSense API defines all functions required to connect to, and stream data from, the StretchSense Fabric Sensors linked to your iOS application
 
 - Author: StretchSense
 
 - Copyright:  2016 StretchSense
 
 - Date: 1/06/2016
 
 - Version:    1.0.0
 
 - note: Within the StretchSenseClass
	-	Peripherals lists (available, connected, saved)
	-	General settings  (number of samples to hold in memory, sampling time, average filtering value)
	-	Feedback information
 
 ```swift
 //Example 1: Connect to the available sensors
 
 class ViewController: UIViewController {
 
 var stretchsenseObject = StretchSenseAPI()
 
 override func viewDidLoad() {
    // This function is the first function called by the View Controller
    super.viewDidLoad()
 
    // Init the StretchSense API and Bluetooth
    stretchsenseObject.startBluetooth()
    // Start Scanning new peripheral
    stretchsenseObject.startScanning()
    }
 
 @IBAction func connect(sender: AnyObject) {
    // Get all available peripherals
    var listPeripheralAvailable = stretchsenseObject.getListPeripheralsAvailable()
    // Explore all the available peripherals
    for myPeripheralAvailable in listPeripheralAvailable{
        // Connect to all available, peripheral devices
        stretchsenseObject.connectToPeripheralWithCBPeripheral(myPeripheralAvailable)
        print(myPeripheralAvailable)
    }
 }
 
 @IBAction func printValue(sender: AnyObject) {
    // Get a list of all connect perihpheral devices
    var listPeripheralConnect = stretchsenseObject.getListPeripheralsConnected()
    // Print current capacitance value from all of the connected peripherals
    for myPeripheralConnected in listPeripheralConnect{
        // Print the value of all the peripheral connected
        print(myPeripheralConnected.value)
    }
 }
}
 
 
 //Example 2: Use notifications to trigger continuous, real-time sampling of capacitance values from 3 sensors (already connected)
 
 class ViewController: UIViewController {
 
 override func viewDidLoad() {
    // This function is the first function called by the View Controller
    super.viewDidLoad()
 
    // Create the notifier
    let defaultCenter = NSNotificationCenter.defaultCenter()
    // Set the observers for each of the 3 sensors (just add lines and functions to add more sensors)
    defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected0), name: "UpdateValueNotification0",object: nil)
    defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected1), name: "UpdateValueNotification1",object: nil)
    defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected2), name: "UpdateValueNotification2",object: nil)
    }
 
 func newValueDetected0() {
    // A notification has been detected from the sensor 0, the function newValueDetected0() is called
    if listPeripheralConnected.count > 0 {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        print("value sensor 0 updated, new value: (\listPeripheralsConnected[0].value) ")
    }
 }
 
 func newValueDetected1() {
    // A notification has been detected from the sensor 1, the function newValueDetected1() is called
    if listPeripheralConnected.count > 1 {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        print("value sensor 1 updated, new value: (\listPeripheralsConnected[1].value) ")
    }
 }
 
 func newValueDetected2() {
    // A notification has been detected from the sensor 2, the function newValueDetected2() is called
    if listPeripheralConnected.count > 2 {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        print("value sensor 2 updated, new value: (\listPeripheralsConnected[2].value) ")
    }
 }
 */
class StretchSenseAPI: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - VARIABLES
    
    // MARK: - Variables : Manager & List Peripherals
    
    /// The manager of all the discovered peripherals
    private var centralManager : CBCentralManager!
    
    /** The list of all the **peripherals available** detected nearby the user device (during a bluetooth scan event)
     
    - note:  Before being connected, the peripheral object is typed CBPeripheral (identifier.UUIDString, CBPeripheralState.Connected, CBPeripheralState.Disconnected)
     
     */
    private var listPeripheralAvailable : [CBPeripheral?] = []
    
    /** The list of **peripherals currently connected** to the centralManager
     
    - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
     
    */
    private var listPeripheralsConnected = [StretchSensePeripheral]()
    
    /** The **saved peripherals** that where once connected to the centralManager
     
    - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
     
    */
    private var listPeripheralsOnceConnected : [StretchSensePeripheral] = [StretchSensePeripheral()]
    
    
    // MARK:  Variables : Services & Characteristics UUID
    
    /// The **name** used to filter bluetooth scan results and find only the StretchSense Sensor
    private var deviceName = "StretchSense"
    /// The UUID used to filter bluetooth scan results and find the **services** from the StretchSense Sensor
    private var serviceUUID = CBUUID(string: "00001501-7374-7265-7563-6873656e7365")
    
    /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Sensor
    private var dataUUID = CBUUID(string: "00001502-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Sensor
    private var shutdownUUID = CBUUID(string: "00001504-7374-7265-7563-6873656e7365")
    /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Sensor
    private var samplingTimeUUID = CBUUID(string: "00001505-7374-7265-7563-6873656e7365")
    
    
    // MARK:  Variables : Set sensor & Info
    
    /// Number of **data samples** within the filtering array
    var numberOfSample = 50
    /// Initialisation value of the **sampling time value**
    /// notes: SamplingTime = (value + 1) * 40ms
    var samplingTimeNumber : UInt8 = 0
    /// Size of the filter based on the **Number of samples**
    var filteringNumber : UInt8 = 0
    /// **Feedback** from the sensor
    private var informationFeedBack = ""
    
    
    // MARK: -  FUNCTIONS
    
    // MARK: - Function: Scan/Connect/Disconnect
    
    /**
     Initialisation of the **Manager**
     
     - note: Must be the first function called, to check if bluetooth is enabled and initialise the manager
     
     - parameter: Nothing
     
     - returns: Nothing
     
     */
    func startBluetooth(){
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    /**
     **Start scanning** for new peripheral
     
     - parameter  Nothing:
     
     - returns: Nothing
     
     */
    func startScanning() {
        
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    /**
     **Stop the bluetooth** scanning
     
     - parameter Nothing
     
     - returns: Nothing
     
     */
    func stopScanning(){
        
        self.centralManager.stopScan()
    }
    
    
    /**
     Function to **connect** the manager to an available peripheral
     
     - note: If the string UUID given does not refer to an available peripheral, do nothing
     - note: Variation of the function connectToPeripheralWithCBPeripheral

     - parameter uuid : the string UUID of the available peripheral you want to connect.
     
     - returns: Nothing
     
     */
    func connectToPeripheralWithUUID(uuid : String){
        
        let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
        
        if listOfPeripheralAvailable.count != 0 {
            for myPeripheralAvailable in listOfPeripheralAvailable{
                if (uuid == myPeripheralAvailable!.identifier.UUIDString){
                    if (myPeripheralAvailable!.state == CBPeripheralState.Disconnected){
                        self.centralManager.connectPeripheral(myPeripheralAvailable!, options: nil)
                    }
                }
            }
        }
    }
    
    /**
     Function to **connect** the manager to an available peripheral
     
     - parameter myPeripheral : the peripheral available (type: CBPeripheral) you want to connect
     
     - returns: Nothing
     
     */
    func connectToPeripheralWithCBPeripheral(myPeripheral : CBPeripheral?){
        
        self.centralManager.connectPeripheral(myPeripheral!, options: nil)
        myPeripheral!.discoverServices(nil)
    }
    
    /**
     Function to **disconnect** from a connected peripheral
     
     - note: If the UUID given does not refer to a connected peripheral, do nothing
     
     - parameter uuid : the string UUID of the peripheral you want to disconnect.
     
     - returns: Nothing
     
     */
    func disconnectOnePeripheralWithUUID(uuid : String){
        
        let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
        
        if listOfPeripheralAvailable.count != 0 {
            for myPeripheral in listOfPeripheralAvailable{
                if (uuid == myPeripheral!.identifier.UUIDString){
                    if (myPeripheral!.state == CBPeripheralState.Connected){
                        self.centralManager.cancelPeripheralConnection(myPeripheral!)
                    }
                }
            }
        }
    }
    
    /**
     Function to **disconnect** from a connected peripheral
     
     - note: Variation of the function connectToPeripheralWithUUID
     
     - parameter myPeripheral : the peripheral connected (type CBPeripheral) you want to disconnect.
     
     - returns: Nothing
     
     */
    func disconnectOnePeripheralWithCBPeripheral(myPeripheral : CBPeripheral){
        
        centralManager.cancelPeripheralConnection(myPeripheral)
    }
    
    /**
     Function to **disconnect all** peripherals
     
     - parameter Nothing
     
     - returns: Nothing
     
     */
    func disconnectAllPeripheral(){
        
        for myPeripheral in listPeripheralAvailable {
            centralManager.cancelPeripheralConnection(myPeripheral!)
        }
    }
    
    
    // MARK: Function: Lists of peripherals
    
    /**
     Get the list of all the **available peripherals** with their information (Identifier, UUID, name, state)
     
     - parameter Nothing
     
     - returns: The available peripherals
     
     */
    func getListPeripheralsAvailable() -> [CBPeripheral?]   {
        
        return listPeripheralAvailable
    }
    
    /**
     Return the list of the **UUID's of the available peripherals**
     
     - parameter Nothing
     
     - returns: The UUID of all the peripheral available
     
     */
    func getListUUIDPeripheralsAvailable() -> [String] {
        
        var uuid : [String] = []
        let numberOfPeripheralAvailable = listPeripheralAvailable.count
        if numberOfPeripheralAvailable != 0 {
            for i in 0...numberOfPeripheralAvailable-1 {
                uuid += [(listPeripheralAvailable[i]!.identifier.UUIDString)]
            }
        }
        return uuid
    }
    
    /**
     Get the list of all the **connected peripherals** with their information (UUID, values, color )
     
     - parameter Nothing
     
     - returns: The peripherals connected
     
     */
    func getListPeripheralsConnected() -> [StretchSensePeripheral]{
        
        return listPeripheralsConnected
    }
    
    /**
     Get the list of all the **peripherals that have been or currently are connected** with their information (UUID, values, color )
     
     - parameter Nothing
     
     - returns: The peripherals that have been or currently are connected to the manager
     */
    func getListPeripheralsOnceConnected() -> [StretchSensePeripheral]{
        
        return listPeripheralsOnceConnected
    }
    
    
    // MARK: Function: samplingTime / Shutdown
    
    /**
     Return the **samplingTime's value** of the peripheral	
     
     - note: SamplingTime is the interval between two data packets (SamplingTime = (value + 1) * 40ms)
     
     - parameter myPeripheral: The peripheral you want the samplingTime value
     
     - returns: The value of the samplingTime, -1 in the event of failure
     
     */
    func getSamplingTimeValue(myPeripheral : CBPeripheral!) -> Int{
        
        if myPeripheral!.state == CBPeripheralState.Connected{
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.UUID == serviceUUID {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        // check for sampling time characteristic
                        if thisCharacteristic.UUID == samplingTimeUUID {
                            if thisCharacteristic.value != nil{
                                // the value is stored as NSData in the Class, we convert it to Int
                                let valueNSData = thisCharacteristic.value!
                                let valueInt:Int! = Int!(Int(valueNSData.hexadecimalString()!, radix: 16))
                                return valueInt
                            }
                            else {return -1}
                        }
                    }
                }
                else { return -1 }
            }
            return -1
        }
        else { return -1 }
    }
    
    /**
     Return the **shutdown's value** of the peripheral
     
     - parameter myPeripheral: The peripheral you want the shutdown value
     
     - returns: The value of the shutdown
     
     */
    func getShutdownValue(myPeripheral : CBPeripheral!) -> Int{
        
        if myPeripheral!.state == CBPeripheralState.Connected{
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.UUID == serviceUUID {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        // check for data characteristic
                        if thisCharacteristic.UUID == shutdownUUID {
                            if thisCharacteristic.value != nil{
                                // the value is stored as NSData in the Class, we convert it to Int
                                let valueNSData = thisCharacteristic.value!
                                let valueInt:Int! = Int!(Int(valueNSData.hexadecimalString()!, radix: 16))
                                return valueInt
                            }
                            else {return -1}
                        }
                    }
                }
                else { return -1 }
            }
            return -1
        }
        else { return -1 }
    }
    
    /**
     Update the **samplingTime** of a selected peripheral device
     
     - note: SamplingTime = (value + 1) * 40ms
     
     - parameter myPeripheral: The peripheral you want to update
     - parameter dataIn: The sampling time (data rate) value you want to set for this peripheral
     
     - returns: Nothing
     
     */
    func writeSamplingTime(dataIn: UInt8, myPeripheral : CBPeripheral?) {
        // The UInt8 need to be convert in NSData before be send
        var dataUint8: UInt8 = dataIn
        let dataNSData = NSData(bytes: &dataUint8, length: 1)
        if (myPeripheral!.state == CBPeripheralState.Connected){
            for service in myPeripheral!.services! {
                let thisService = service as CBService
                if thisService.UUID == serviceUUID {
                    for charateristic in service.characteristics! {
                        let thisCharacteristic = charateristic as CBCharacteristic
                        if thisCharacteristic.UUID == samplingTimeUUID {
                            // Once we have the correct Characteristic, we can send the data
                            myPeripheral!.writeValue(dataNSData, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Change the **value of the shutdown** from the peripheral
     
     - parameter myPeripheral: The peripheral you want to update
     - parameter dataIn: The shutdown value you want to set for this peripheral [0 - Stay on, 1 - Shutdown]
     
     - returns: Nothing
     
     */
    func writeShutdown(dataIn: UInt8, myPeripheral : CBPeripheral?) {
        
        // The UInt8 need to be convert in NSData before be send
        
        var dataUint8: UInt8 = dataIn
        let dataNSData = NSData(bytes: &dataUint8, length: 1)
        for service in myPeripheral!.services! {
            let thisService = service as CBService
            if thisService.UUID == serviceUUID {
                for charateristic in service.characteristics! {
                    let thisCharacteristic = charateristic as CBCharacteristic
                    if thisCharacteristic.UUID == shutdownUUID {
                        // Once we have the good Characteristic and Characteristic, we can send the data
                        myPeripheral!.writeValue(dataNSData, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                    }
                }
            }
        }
    }
    
    
    // MARK:  Function: Optional
    
    
    /**
     **Average** Provides an averaged (FIR moving point) value of the capacitance feedback from a single peripheral
     
     - note: The filter is a moving average FIR filter
     
     - Example:
     Assuming a filter size of 4 points
     and an input set of values: 	[0 0 0 0 0 1.00 1.00 1.00 1 1 1 1 0.00 0.00 0.00 0 0 0 0]
     The output values will be : 	[0 0 0 0 0 0.25 0.50 0.75 1 1 1 1 0.75 0.50 0.25 0 0 0 0]
     
     - parameter myPeripheral:  The peripheral value you want to receive data from
     - parameter averageNumber: The size of the moving point average filter (points)
     
     - returns: The averaged value
     
     */
    func averageFIR(averageNumber: Int, mySensor: StretchSensePeripheral)-> CGFloat{
        if averageNumber == 0 || averageNumber == 1 {
            return mySensor.value
        }
        else {
            // we add the lastvalue (mySensor.value) and the 'averageNumber' values from the sensor
            var sumValue = mySensor.value
            for i in 0 ... averageNumber-2 {
                sumValue += mySensor.previousValueRawFromTheSensor[mySensor.previousValueRawFromTheSensor.count-1 - i]
            }
            // Then we divide by the number of values added to get the average
            return CGFloat(sumValue/CGFloat(averageNumber))
        }
    }
    
    /**
     **Average** Provides an averaged (IIR moving point) value of the capacitance feedback from a single peripheral
     
     - note: The filter is a moving average IIR filter (The result of a previous calculation will effect this value)
     
     - Example:
     Assuming a filter size of 4 points
     and an input set of values: 	[0 0 0 0 0 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00 1.00]
     The output values will be : 	[0 0 0 0 0 0.25 0.31 0.39 0.48 0.54 0.60 0.66 0.70 0.74 0.77 0.80 0.83 0.85 0.87]
     
     - parameter myPeripheral:  The peripheral value you want to receive data from
     - parameter averageNumber: The size of the moving point average filter (points)
     
     - returns: The value averaged
     
     */
    func averageIIR(averageNumber: Int, mySensor: StretchSensePeripheral)-> CGFloat{
        
        if averageNumber == 0 || averageNumber == 1 {
            return mySensor.value
        }
        else {
            // we add the lastvalue (mySensor.value) and the 'averageNumber' values from the sensor
            var sumValue = mySensor.value
            for i in 0 ... averageNumber-2 {
                sumValue += mySensor.previousValueAveraged[mySensor.previousValueAveraged.count-1 - i]
            }
            // Then we divide by the number of values added to get the average
            return CGFloat(sumValue/CGFloat(averageNumber))
        }
    }
    
    /**
     **Convert** the Raw data from the sensor characterisitic to a capacitance value, units pF (picoFarads)
     
     - note: Capacitance(pF) = RawData * 0.10pF
     
     - parameter rawData: The raw data from the peripheral
     
     - returns: The real capacitace value in pF
     
     */
    func convertRawDataToCapacitance(rawDataInt: Int) -> Float{
        
        // Capacitance(pF) = RawData * 0.10pF
        return Float(rawDataInt)*0.1
    }
    
    /**
     Returns the number available peripheral devices that are not connected
     
     - parameter Nothing
     
     - returns: The number of peripherals available
     
     */
    func getNumberOfPeripheralAvailable() -> Int {
        
        return listPeripheralAvailable.count
    }
    
    /**
     Returns the number of connected peripheral
     
     - parameter Nothing
     
     - returns: The number of connected peripherals
     
     */
    func getNumberOfPeripheralConnected() -> Int {
        
        return listPeripheralsConnected.count
    }
    
    /**
     Return the last **information** (event update) received from the sensor
     
     - parameter Nothing
     
     - returns: The last information from the sensor
     
     */
    func getLastInformation() -> String{
        
        return informationFeedBack
    }
    
    
    // MARK: - Background Function: Central & Peripheral Manager
    
    /// Check the state of the Bluetooth Low Energy
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        switch (central.state){
        case .PoweredOff:
            // Bluetooth on this device is currently powered off
            informationFeedBack = "BLE is powered off"
        case .PoweredOn:
            // Bluetooth LE is turned on and ready for communication
            informationFeedBack = "Bluetooth is powered on"
        case .Resetting:
            // The BLE Manager is resetting; a state update is pending
            informationFeedBack = "BLE is resetting"
        case .Unauthorized:
            // This app is not authorized to use Bluetooth Low Energy
            informationFeedBack = "BLE is unauthorized"
        case .Unknown:
            // The state of the BLE Manager is unknown, wait for another event
            informationFeedBack = "BLE is unknown"
        case .Unsupported:
            // This device does not support Bluetooth Low Energy.
            informationFeedBack = "BLE is not supported"
        }
        
        // Notify the viewController when the state has updated, this can be used to prompt events
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
    }
    
    /// Scan and filter all Bluetooth Low energy devices to find any available StretchSense peripherals
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral?, advertisementData: [String : AnyObject], RSSI: NSNumber){
        
        // Update information
        informationFeedBack = "Searching for peripherals"
        // Notify the viewController that the state has updated, this can be used to prompt events
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
        
        if (central.state == CBCentralManagerState.PoweredOn){
            var inTheList = false
            let peripheralCurrent = peripheral
            
            for periphOnceConnected in self.listPeripheralsOnceConnected {
                if periphOnceConnected.uuid == peripheral?.identifier.UUIDString{
                    //If the peripheral discovered was once connected, we connect directly
                    connectToPeripheralWithUUID((peripheral?.identifier.UUIDString)!)
                }
                    
                    
                else {
                    
                    // If the peripheral discovered was never connected to the app we identify it
                    let nameOfPeripheralFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
                    if (nameOfPeripheralFound == deviceName) {
                        // If it's a stretchsense device
                        
                        // Update information
                        informationFeedBack = "New Sensor Detected, Click to Connect/Disconnect"
                        // Notify the viewController that the info has been updated and so has to be reload
                        let defaultCenter = NSNotificationCenter.defaultCenter()
                        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
                        
                        if (self.listPeripheralAvailable.count == 0) {
                            // If the list is empty, we add the new peripheral detected directly
                            self.listPeripheralAvailable.append(peripheralCurrent)
                        }
                        else{
                            // Else we have to look if it's not yet in the list
                            for periphInList in self.listPeripheralAvailable{
                                if peripheral!.identifier == periphInList?.identifier{
                                    inTheList = true
                                }
                            }
                            if inTheList == false{
                                // If the new peripheral detected is not in the list, we add it to the list
                                self.listPeripheralAvailable.append(peripheralCurrent)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Establish a connection with a peripheral and initialise a StretchSensePeriph object
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        // Update information
        informationFeedBack = "Connecting peripheral"
        // Notify the viewController that the info has been updated and so has to be reload
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
        
        // We create a newSensor with the UUID and set his unique color with his number of appearance in the listPeripheralOnceConnected
        let newSensor = StretchSensePeripheral()
        newSensor.uuid = peripheral.identifier.UUIDString
        newSensor.value = 0
        newSensor.uniqueNumber = listPeripheralsOnceConnected.count-1
        newSensor.previousValueAveraged = [CGFloat](count: numberOfSample, repeatedValue:0)
        
        var wasThePeriphOnceConnected = false
        for peripheralOnceConnected in listPeripheralsOnceConnected{
            if peripheralOnceConnected.uuid == peripheral.identifier.UUIDString {
                // If the peripheral was once connected, we copy the color and previous values
                wasThePeriphOnceConnected = true
                newSensor.uniqueNumber = peripheralOnceConnected.uniqueNumber
                newSensor.previousValueAveraged = peripheralOnceConnected.previousValueAveraged
                newSensor.previousValueRawFromTheSensor = peripheralOnceConnected.previousValueRawFromTheSensor
            }
        }
        // Check if the peripheral has previously been connected
        if wasThePeriphOnceConnected == false {
            listPeripheralsOnceConnected.append(newSensor)
        }
        
        peripheral.delegate = self
        // Stop scanning for new devices
        //stopScanning()
        listPeripheralsConnected.append(newSensor)
        
        peripheral.discoverServices([serviceUUID])
    }
    
    /// When a device is disconnected, we remove it from the value list and the peripheralListAvailable
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        // Check errors
        if (error != nil) {
            print("Error :  \(error?.localizedDescription)");
        }
        
        let peripheralToDelete = peripheral.identifier.UUIDString
        let listUUID = getListUUIDPeripheralsAvailable()
        let indexPositionToDelete = listUUID.indexOf({ $0 == peripheralToDelete }) // looking for the index of the peripheral to delete in the list
        listPeripheralAvailable.removeAtIndex(Int(indexPositionToDelete!))  // remove the peripheral from the list
        
        let indexPositionToDelete2 = listPeripheralsConnected.indexOf({ $0.uuid == peripheralToDelete }) // looking for the index of theperipheral to delete in the list
        listPeripheralsConnected.removeAtIndex(Int(indexPositionToDelete2!))  // remove the peripheral from the list
        
        // We start scanning for new peripherals
        central.scanForPeripheralsWithServices(nil, options: nil)
        
        // Update information
        informationFeedBack = "Peripheral Disconnected"
        // Notify the viewController that the info has been updated and so has to be reloaded
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
        
        startScanning()
    }
    
    
    /// When the specified services are discovered, the peripheral calls the peripheral:didDiscoverServices: method of its delegate object
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        // Check errors
        if (error != nil) {
            print("Error :  \(error?.localizedDescription)");
        }
        
        // Update information
        informationFeedBack = "Discovering peripheral services"
        // Notify the viewController that the info has been updated and so has to be reload
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
        
        // Expore each service to find characteristics
        for service in peripheral.services! {
            let thisService = service as CBService
            if service.UUID == serviceUUID {
                peripheral.discoverCharacteristics(nil, forService: thisService) //call the didDiscoverCharacteristicForService()
            }
        }
    }
    
    /// Once connected to a peripheral, enable notifications on the Sensor characteristic
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        // Update information
        informationFeedBack = "Sensor ready to use"
        // Notify the viewController that the info has been updated and so has to be reload
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName("UpdateInfo", object: nil, userInfo: nil)
        
        // Check the UUID of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            // check for data characteristic
            if thisCharacteristic.UUID == dataUUID {
                peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                //print("Charac DATA: \(thisCharacteristic)")
            }
        }
    }
    
    /// Get/read capacitance data from the peripheral device when a notificiation is received
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        // Check errors
        if (error != nil) {
            print("Error Upload :  \(error?.localizedDescription)");
        }
        if listPeripheralsConnected.count != 0 {
            for myPeripheral in listPeripheralsConnected{
                if myPeripheral.uuid == peripheral.identifier.UUIDString{
                    let ValueData = characteristic.value!
                    // Convert NSData to array of signed 16 bit values
                    
                    let valueRaw = Int(ValueData.hexadecimalString()!, radix: 16)!
                    myPeripheral.value = CGFloat(convertRawDataToCapacitance(valueRaw))
                    
                    
                    // Shifting of the previous value
                    for j in 0 ... myPeripheral.previousValueAveraged.count-2{
                        myPeripheral.previousValueAveraged[j] = myPeripheral.previousValueAveraged[j+1]
                        myPeripheral.previousValueRawFromTheSensor[j] = myPeripheral.previousValueRawFromTheSensor[j+1]
                    }
                    myPeripheral.previousValueRawFromTheSensor[myPeripheral.previousValueRawFromTheSensor.count-1] = myPeripheral.value
                    myPeripheral.previousValueAveraged[myPeripheral.previousValueAveraged.count-1] = averageIIR(Int(filteringNumber), mySensor: myPeripheral)
                    
                    // Notify the viewController that the value has been updated and so has to be reloaded
                    let defaultCenter = NSNotificationCenter.defaultCenter()
                    // We send a notification with the number of the sensor
                    defaultCenter.postNotificationName("UpdateValueNotification\(myPeripheral.uniqueNumber)", object: nil, userInfo: nil)
                }
            }
        }
    }
}

// MARK: - EXTENSION

extension NSData {
    
    /**
     Convert the hexadecimal value into a String
     
     - parameter Nothing
     
     - returns: The value converted
     
     */
    func hexadecimalString() -> String? {
        /* Used to convert NSData to String */
        if let buffer = Optional(UnsafePointer<UInt8>(self.bytes)) {
            var hexadecimalString = String()
            for i in 0..<self.length {
                hexadecimalString += String(format: "%02x", buffer.advancedBy(i).memory)
            }
            return hexadecimalString
        }
        return nil
    }
}


extension ViewController : MFMailComposeViewControllerDelegate {
    
    /**
     Convert a [String] to NSData
     
     - parameter array: the array of String
     
     - returns: array of String converted
     
     */
    func stringArrayToNSData(array: [String]) -> NSData {
        
        let data = NSMutableData()
        let terminator = [0]
        for string in array {
            if let encodedString = string.dataUsingEncoding(NSUTF8StringEncoding) {
                data.appendData(encodedString)
                data.appendBytes(terminator, length: 1)
            }
            else {
                NSLog("Cannot encode string \"\(string)\"")
            }
        }
        return data
    }
    
    /**
     Save and Share a [String]
     - Note: Format and save recorded capacitance data to file (.csv)
     
     - parameter array: the array of String
     
     - returns: Nothing
     
     */
    func saveAndExport(stringArrayToShare: [String]) {
        
        let exportFilePath = NSTemporaryDirectory() + "StretchSense_Record.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(exportFilePath, contents: NSData(), attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: NSFileHandle? = nil
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            print( "Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let nsdataToShare: NSData = stringArrayToNSData(stringArrayToShare)
           
            fileHandle!.writeData(/*csvData!*/ nsdataToShare)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
}
