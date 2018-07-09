//
//  PWMCameraController.swift
//  PreviewWithMetal
//
//  Created by SXC on 2018/7/6.
//  Copyright © 2018年 sxc. All rights reserved.
//

import UIKit
import AVFoundation

protocol PWMCameraDelegate {
    func cameraDidOutputSampleBuffer(sampleBuffer: CMSampleBuffer)
}

class PWMCameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession!
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    let sampleBufferQueue = DispatchQueue(label: "com.preview_with_metal.sampleBufferQueue")
    
    var delegate: PWMCameraDelegate?
    
    override init() {
        super.init()
        self.setupCamera()
    }
    
    func setupCamera() {
        session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(deviceInput) else {
                return
            }
            session.addInput(deviceInput)
        } catch {
            return
        }
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] as [String : Any]
        guard session.canAddOutput(dataOutput) else {
            return
        }
        dataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        session.addOutput(dataOutput)
        session.sessionPreset = .hd1280x720
    }
    
    func startCameraSession() {
        session.startRunning()
    }
    
    func stopCameraSession() {
        session.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let delegate = self.delegate {
            delegate.cameraDidOutputSampleBuffer(sampleBuffer: sampleBuffer)
        }
    }
}
