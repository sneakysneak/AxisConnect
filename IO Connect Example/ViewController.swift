//
//  ViewController.swift
//  IOConnect
//
//  Created by sneakysneak on 01/11/2018.
//  Copyright © 2018 sneakysneak. All rights reserved.
//


import UIKit
import CoreMotion
import CocoaMQTT

// on a raspberry pi mosquitto installed in terminal
// use command mosquitto -v and the host's ip address
class ViewController: UIViewController {
    //don't use the phone's ip address use the target's one!
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "172.16.3.146", port: 1883)
    var motionManager = CMMotionManager()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometerX()
    }
    
    @IBOutlet weak var displayAccelerometer: UILabel!
    
    @IBAction func btnConnect(_ sender: UIButton) {
        mqttClient.connect()
    }
    
    @IBAction func btnDisconnect(_ sender: UIButton) {
        mqttClient.disconnect()
    }
    
    @IBAction func showData(_ sender: Any) {
        print("fewfew")
    }
    @IBAction func displayAcc(_ sender: UISwitch) {
    }
    
    @IBOutlet weak var accelTagX: UILabel!
    
    @IBOutlet weak var accelSwitch: UISwitch!
    
    //SWITCH button
    @IBAction func stateChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            startAccelerometerX()
            
            var fasz = mqttClient.publish("rpi", withString: "jujj")
            print(fasz)
//            mqttClient.publish(String, withString: <#T##String#>)
        }else {
            stopAccelerometerX()
        }
    }
    
  
    func startAccelerometerX () {
        print("Start Accelerometer Updates")
        //how fast is the check 0 fastest
        motionManager.accelerometerUpdateInterval = 0
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerData:CMAccelerometerData?, error: Error?) in
            if (error != nil ) {
                print("Error")
            } else {
                
                let accelX = accelerData?.acceleration.x
                
                self.accelTagX.text = String(format: "%.02f", accelX!)
                var acctext = String(format: "%.02f", accelX!)
//                self.postAccelerometerDataX()
                //print("Accelerometer X: \(accelX!)")
                
                
//                self.mqttClient.publish("rpi/gpio", withString: acctext)
            }
        })
    }

    func stopAccelerometerX () {
        self.motionManager.stopAccelerometerUpdates()
        self.accelTagX.text = "--"
        print("Accelerometer X Stopped")
    }
}

