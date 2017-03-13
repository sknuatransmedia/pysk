//
//  ViewController.swift
//  Puthuyugam
//
//  Created by Apple on 06/03/17.
//  Copyright © 2017 nuatransmedia. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
struct constant{
    
    static let endPointURL = "http://pylive.ptapps2016.com/v1/stream/ios"
    
}
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}


class ViewController: UIViewController {
    
    
    @IBOutlet var imgScreenShot: UIImageView!
    
    
    @IBOutlet var imgPlayButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if Reachability.isConnectedToNetwork() == true {
            
        imgPlayButton.rotate360Degrees()
        serverRequestFromPY(urvalName: constant.endPointURL)
            
        } else {
           
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func  serverRequestFromPY(urvalName:String)
    {
        let urValForServer: NSURL = NSURL(string: urvalName)!
        let request: NSURLRequest = NSURLRequest(url:urValForServer as URL)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Work in Error")
            } else {
                //                let httpResponse = response as? HTTPURLResponse
                self.imgPlayButton.layer.removeAllAnimations()
                
                
                do{
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    if let currentConditions = parsedData["PYLive"]as? [[String: AnyObject]]{
                        let objectVal = currentConditions[0]
                        
                        
                        print("First Value\(objectVal["952K"]!)")
                        
                        
                        
                        let defaults = UserDefaults.standard
                        defaults.set(objectVal["952K"]!, forKey: "952k")
                        defaults.set(objectVal["464K"]!, forKey: "464k")
                        defaults.set(objectVal["208K"]!, forKey: "208k")
                        defaults.set(objectVal["80K"]!, forKey: "80k")
                        defaults.set(objectVal["Audio"]!, forKey: "Audio")
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                catch{
                    
                }
                
            }
        })
        
        dataTask.resume()
        
    }
    
    @IBAction func btnPlayer(_ sender: Any) {
        
        
        if Reachability.isConnectedToNetwork() == true {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LivePlayer") as! LiveTVPlayerViewController
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        

        
        
        
       
        
    }
    
    
}

