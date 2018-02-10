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
    
    
    func captured(image: UIImage) {
        if(counter == 0){
            imageOutlet.image = OpenCVWrapper.detectCircles(image)
        }
        else if(counter == 1){
            imageOutlet.image = OpenCVWrapper.fillShape(image)
        }
        else if(counter == 2){
            imageOutlet.image = OpenCVWrapper.makeItGrayScale(image)
        }
        else if(counter == 3){
            imageOutlet.image = OpenCVWrapper.makeThreshold(image)
//            THIS FACE DETECTION IS TOO SLOW - CPU HEAVY -
//            let res = OpenCVWrapper.detectFaces(image)
//            if(res != nil){
//                imageOutlet.image = res
//            }
//            else{
//                imageOutlet.image = image
//            }
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
            counter = 3
        }else if(counter == 3){
            counter = 0
        }
    }
    
    
}

