# StretchSense Bluetooth LE iOS Communication Library

StretchSense is a global supplier of soft sensors. These soft sensors are perfect for measuring the complex movements of people and soft objects in our environments. 

## About
### Background
The StretchSense iOS API has been developed to enable communication between a StretchSense Fabric Evaluation circuit and a BLE enabled iOS device. This library was developed using XCode 7.3 with Swift 2.2.
First download and unzip the StretchSense Library from http://github.com/Stretchsense.

### Adding the Library to your application
Once your application is created in XCode, you have to import the Stretchsense Library.
To do so, copy/paste the “StretchSenseLibrary.swift” to the folder containing the “viewcontroller.swift” of your application.

Then, on XCode, in the left sidebar, right click and “Add Files to ‘nameOfYourApplication’”. Choose the “StretchSenseLibrary.swift” and “Add”.
Your can now use the functions provided by the StretchSense iOS Library.
### Quick Start using the StretchSense iOS Library

The steps required to use this library and connect the StretchSense fabric sensor to your Apple Device are:

*	Initialization: Turn on the Bluetooth and initialize the library
*	Discovery: 	Scan for devices
*	Connection: Connect to the device
*	Streaming:  Start reading data

#### Initialization
First, on your viewController.swift, you need to declare your object from the StretchSense Class. All communication with the sensor will go through this object. 

	let stretchsenseObject = StretchSenseAPI()

Using this object, you have to start the Bluetooth:
 
	stretchsenseObject.startBluetooth()

#### Discovery
Your manager and peripheral list are now set up. You can start scanning for a peripheral.

	stretchsenseObject.startScanning()

If any StretchSense peripherals are found (powered on and not yet connected), you can get the list of their UUID's (Universally Unique IDentifier).

  	var listPeripheralAvailable : [String] = []
	listPeripheralAvailable = stretchsenseObject.getListUUIDPeripheralsAvailable()

#### Connection

Once a peripheral has been found, the connect function will create a link between your application and the device. The library allow you to connect to the peripheral using his UUID or the whole information of the peripheral, as a CBPeripheral. The functions are respectively: connectToPeripheralWithUUID() and  connectToPeripheralWithCBPeripheral()

This example use the first function. You can connect any peripheral available from the list, just change the index (here 0 refers to the first peripheral detected). 

	myPeripheralAvailable = listPeripheralAvailable[0]         
	stretchsenseObject.connectToPeripheralWithUUID(myPeripheralAvailable)

If you want to connect all the peripherals available, you can use a for loop:

	var listPeripheralAvailable : [String] = []
	for myPeripheralAvailable in listPeripheralAvailable {
		stretchsenseObject.connectToPeripheralWithUUID(myPeripheralAvailable)
	}

#### Streaming
You are now connected and can start reading data values from the peripheral.

 	var listPeripheralConnected : [StretchSensePeriph] = [StretchSensePeriph()]
    // Get the complete list of all connected Peripheral Devices
    listPeripheralConnected = stretchsenseObject.getListPeripheralsConnected()
    // Select peripheral in list location 0
    var myPeripheralConnected = listPeripheralConnected[0]
    var value = myPeripheralConnected.value
    var uuid = myPeripheralConnected.uuid


For each call you will have the instantaneous value. To refresh the value each time you have a new data value from the peripheral, you need to use notifications and observer. The notifications are already integrated in the library under the name “UpdateValueNotification[#ofTheSensor]” and are ready to use (replace the [#ofTheSensor] by the number of the sensor you want to put an observe on). For each sensor you want to use, add an observer. You just have to create an observer waiting for his notification and send you to another function. Here the function newValueDetected() is called from the observer on the 1st sensor and then asks for a getListDataFromAllPeripheral to refresh the value.
	
    var observerValue = NSNotificationCenter.defaultCenter()

    observerInformation.addObserver(self, selector: #selector(newValueDetected0), 
    name: "UpdateValueNotification0",
    object: nil)

    observerInformation.addObserver(self, selector: #selector(newValueDetected1), 
    name: "UpdateValueNotification1",
    object: nil)

    func newValueDetected0() {
    // This function is called when a notification from the 1st sensor connected is received
    // Add your code here
    }

    func newValueDetected1() {
    // This function is called when a notification from the 2nd sensor connected is received
    // Add your code here
    }



## Compatible Devices

### Bluetooth
This library has been developed exclusively for Bluetooth 4.0 (BLE), also known as Bluetooth Low Energy. Compadible devices and sensors are listed below. 

### StretchSense
Only the StretchSense Fabric Evaluation circuit is compatible with the support library.
http://stretchsense.com/evaluation-kits/fabric-stretch-sensor-evaluation-kit/

### iOS
BLE was first introduce in 2012 and requires a minimum operating system version of iOS 8.0

The following iPhones, iPads and iPod use Bluetooth 4.0:
*	iPhone 4s, 5, 5c, 5s, 6, 6 Plus
*	iPad 3rd generation, 4th generation, Mini, Mini 2, Mini 3, Air, Air 2
*	iPod Touch 5th generation

## License
The 'StretchSense Bluetooth LE iOS Communication Library' is available under the MIT License attached within the root directory of this project.