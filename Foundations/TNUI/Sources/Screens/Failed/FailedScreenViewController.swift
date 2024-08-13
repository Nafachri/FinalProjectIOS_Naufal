//
//  FailedScreenViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import UIKit
import Lottie

public class FailedScreenViewController: UIViewController {

  @IBOutlet weak var animationView: LottieAnimationView!
  public override func viewDidLoad() {
        super.viewDidLoad()
    if let path = Bundle.module.path(forResource: "failed-animation", ofType: "json") {
        let animation = LottieAnimation.filepath(path)
        animationView.animation = animation
    }
    
    animationView!.loopMode = .loop
    animationView!.animationSpeed = 1
    animationView!.play()
    }

}
