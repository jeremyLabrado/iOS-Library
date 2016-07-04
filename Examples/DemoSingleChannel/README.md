# Example 1 - Single Circuit Connection  

StretchSense is a global supplier of soft sensors. These soft sensors are perfect for measuring the complex movements of people and soft objects in our environments. 

## About
### Background
The Single Circuit Connection application has been developed using StretchSense iOS API to demonstrate how to establish a connection between a single StretchSense Fabric Evaluation circuit and a BLE enabled iOS device. This project was developed using XCode 7.3 with Swift 2.2.
This library and additional examples are available on StretchSense's Github Page http://github.com/Stretchsense.

### Usage
The Single Circuit Connection application demonstrates how to use the StretchSense (Bluetooth LE) iOS Library by stepping through the connection process by way of a list of button elements tied to core library functions.

About Buttons:
* StartScanning: Start scanning for new sensor
* Get Peripheral Available: Display the UUID of the first sensor detected
* Connect to this peripheral: Connect the app with the sensor found previously
* Get data: Display the capacitance of the sensor
* Enable auto-refresh: Enable the notification’s use to refresh the value displayed 
* Disable auto-refresh: Disable the notification’s use
	
The red label at the bottom of the screen is the feedback of the sensor. It let you know the state of connection of the sensor.


## Compatible Devices

### Bluetooth
This library has been developed exclusively for Bluetooth 4.0 (BLE), also known as Bluetooth Low Energy. Compatible devices and sensors are listed below. 

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