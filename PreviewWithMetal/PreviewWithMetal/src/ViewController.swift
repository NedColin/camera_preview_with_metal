//
//  ViewController.swift
//  PreviewWithMetal
//
//  Created by SXC on 2018/7/6.
//  Copyright © 2018年 sxc. All rights reserved.
//

import UIKit
import AVFoundation
import MetalKit

class ViewController: UIViewController, PWMCameraDelegate {
    
    var cameraController = PWMCameraController()
    var renderView: MTKView!
    var renderer: PWMPreviewRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.delegate = self

        let device = MTLCreateSystemDefaultDevice()!
        renderView = MTKView(frame: view.frame, device: device)
        view.addSubview(renderView)
        renderView.translatesAutoresizingMaskIntoConstraints = false
        renderView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0).isActive = true
        renderView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0).isActive = true
        renderView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        renderView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        renderer = PWMPreviewRenderer(device: device, for: renderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraController.startCameraSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraController.stopCameraSession()
    }
    
    func cameraDidOutputSampleBuffer(sampleBuffer: CMSampleBuffer) {
        renderer.updateTexture(sampleBuffer: sampleBuffer)
    }
    
}

