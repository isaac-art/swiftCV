//
//  ViewController.swift
//  swiftCV
//
//  Created by Isaac Clarke on 07/02/2018.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, FrameExtractorDelegate {
    
    var counter = 0;
    var frontCam = false;
    
    @IBOutlet weak var imageOutlet: UIImageView!

    var frameExtractor: FrameExtractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //OpenCVVersionLabel.text = OpenCVWrapper.openCVVersionString();
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        if(frontCam){
            frontCam = false;
        frameExtractor.captureSession.stopRunning();
            frameExtractor.position = AVCaptureDevice.Position.back
            frameExtractor.configureSession()
            
            frameExtractor.captureSession.startRunning();
        }else{
            frontCam = true;
        frameExtractor.captureSession.stopRunning();
            frameExtractor.position = AVCaptureDevice.Position.front
            frameExtractor.configureSession()
            frameExtractor.captureSession.startRunning();
        }
    }
    
    func captured(image: UIImage) {
        if(counter == 0){
            imageOutlet.image = OpenCVWrapper.fillShape(image)
        }
        else if(counter == 1){
            imageOutlet.image = OpenCVWrapper.makeItGrayScale(image)
        }
        else if(counter == 2){
            imageOutlet.image = OpenCVWrapper.makeThreshold(image)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedScreen(_ sender: Any) {
        
        if(counter == 0){
            counter = 1
        }else if(counter == 1){
            counter = 2
        }else if(counter == 2){
            counter = 0
        }
    }
    
    
}

