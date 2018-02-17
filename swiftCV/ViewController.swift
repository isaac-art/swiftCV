//
//  ViewController.swift
//  swiftCV
//
//  Created by Isaac Clarke on 07/02/2018.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, FrameExtractorDelegate {
    
    var num = 0;
    var counter = 0;
    var frontCam = false;
    
    @IBOutlet weak var imageOutlet: UIImageView!

    var frameExtractor: FrameExtractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //diable the screen time out
        UIApplication.shared.isIdleTimerDisabled = true
        // Do any additional setup after loading the view, typically from a nib.
        //OpenCVVersionLabel.text = OpenCVWrapper.openCVVersionString();
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    
    func captured(image: UIImage) {
        num += 1
        if(num%2 == 0){
            num = 0
            if(counter == 0){
                imageOutlet.image = OpenCVWrapper.detectShapesV2(image)
            }
            else if(counter == 1){
                imageOutlet.image = OpenCVWrapper.detectShapesV2(image)
            }
            else if(counter == 2){
                imageOutlet.image = OpenCVWrapper.makeItGrayScale(image)
            }
            else if(counter == 3){
                imageOutlet.image = OpenCVWrapper.makeThreshold(image)
            }
            else if(counter == 4){
                imageOutlet.image = OpenCVWrapper.fillShape(image)
            }
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
            counter = 4
        }else if(counter == 4){
            counter = 0
        }
    }
    
    
}

