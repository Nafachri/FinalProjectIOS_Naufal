//
//  SuccessScreenViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import UIKit
import Lottie

public class SuccessScreenViewController: UIViewController {
  
    @IBOutlet weak var animationView: LottieAnimationView!
  public override func viewDidLoad() {
    super.viewDidLoad()
        if let path = Bundle.module.path(forResource: "success-animation", ofType: "json") {
            let animation = LottieAnimation.filepath(path)
            animationView.animation = animation
        }
        
//        animationView!.loopMode = .loop
    animationView!.animationSpeed = 0.5
        animationView!.play()
      }
  
  public init() {
    super.init(nibName: "SuccessScreenViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  }
