# Example 2 - Multiple Circuit Connection  

StretchSense is a global supplier of soft sensors. These soft sensors are perfect for measuring the complex movements of people and soft objects in our environments. 

## About
### Background
The Multiple Circuit Connection application has been developed using StretchSense iOS API to demonstrate how to establish a connection between a multiple StretchSense Fabric Evaluation circuits and a BLE enabled iOS device. This project was developed using XCode 7.3 with Swift 2.2.
This library and additional examples are available on StretchSense's Github Page http://github.com/Stretchsense.

### Usage
The Multiple Circuit Connection application demonstrates how, up to 10, simultaneous connections can be established by using the StretchSense (Bluetooth LE) iOS Library. 

This application displays the list of sensors available and connected in two seperate tables. 
Once a sensor is available (advertising), it's UUID is displayed on the first table. 

Click on the sensor to connect it with the app. The background color of the cell is linked to it state, if it’s green, it’s connected but if it’s grey it’s not. If a sensor is connected, his unique color his displayed as the subtitles of the UUID.

Once a sensor is connected, it appears in the second table. The title is the capacitance value and the subtitle is it's UUID.

This application uses the notifications to refresh the tables.

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