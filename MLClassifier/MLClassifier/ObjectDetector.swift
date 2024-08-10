//
//  ObjectDetector.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import CoreML
import Vision

class ObjectDetector {
    var carDetectionModel: VNCoreMLModel // 차량을 감지하는 모델 (Object Detection)
    var tailLampDetectionModel: VNCoreMLModel // 차량 후미등을 감지하는 모델 (Object Detection)
    var tailLampClassificationModel: VNCoreMLModel // 차량 후미등을 분류하는 모델 (Classification)
    
    init() {
        // TailLampDetecitonModel 로드
        guard let carDetectionModelURL = Bundle.main.url(forResource: "CarDetecting", withExtension: "mlmodelc"),
              let carDetectionModel = try? VNCoreMLModel(for: MLModel(contentsOf: carDetectionModelURL)) else {
            fatalError("CarDetecting 모델을 로드할 수 없습니다.")
        }
        self.carDetectionModel = carDetectionModel
        
        // TailLampDetecitonModel 로드
        guard let tailLampDetectionModelURL = Bundle.main.url(forResource: "TaillightDetector 4", withExtension: "mlmodelc"),
              let tailLampDetectionModel = try? VNCoreMLModel(for: MLModel(contentsOf: tailLampDetectionModelURL)) else {
            fatalError("TaillightDetector 4 모델을 로드할 수 없습니다.")
        }
        self.tailLampDetectionModel = tailLampDetectionModel
        
        // TailLampClassificationModel 로드
        guard let tailLampClassificationModelURL = Bundle.main.url(forResource: "MyImageClassifier", withExtension: "mlmodelc"),
              let tailLampClassificationModel = try? VNCoreMLModel(for: MLModel(contentsOf: tailLampClassificationModelURL)) else {
            fatalError("Tail Lamp ClassificationModel Model 모델을 로드할 수 없습니다.")
        }
        self.tailLampClassificationModel = tailLampClassificationModel
    }
    
    // MARK: - 차량을 감지하는 모델
    func detectCarObjects(in image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]?) -> Void) {
        guard let cgImage = image.cgImage else {
            print("차량을 CGImage로 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: carDetectionModel) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("차량 사진을 가져올 수 없습니다.")
                completion(nil)
                return
            }
            completion(results)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("차량 인식 요청을 수행할 수 없습니다: \(error)")
                completion(nil)
            }
        }
    }
    
    
    // MARK: - 차량 후미등을 감지하는 모델
    func detectTailLampObjects(in image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]?) -> Void) {
        guard let cgImage = image.cgImage else {
            print("후미등을 CGImage로 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: tailLampDetectionModel) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("후미등 사진을 가져올 수 없습니다.")
                completion(nil)
                return
            }
            completion(results)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("객체(후미등) 인식 요청을 수행할 수 없습니다: \(error)")
                completion(nil)
            }
        }
    }
    
    
    
    // MARK: - 차량 후미등을 분류하는 모델
    func classifyObject(in image: UIImage, completion: @escaping (VNClassificationObservation?) -> Void) {
        guard let cgImage = image.cgImage else {
            print("CGImage로 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: tailLampClassificationModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                print("분류 결과를 가져올 수 없습니다.")
                completion(nil)
                return
            }
            completion(topResult)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("분류 요청을 수행할 수 없습니다: \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - 이미지 크롭
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage, let croppedCGImage = cgImage.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: croppedCGImage)
    }
}
