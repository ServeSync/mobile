//
//  RollCallVC.swift
//  PBL6
//
//  Created by KietKoy on 02/11/2023.
//

import UIKit
import SwiftQRScanner
import CoreLocation

class RollCallVC: BaseVC<RollCallVM> {
    private var configuration = QRScannerConfiguration()
    private var scanner: QRCodeScannerController?
    private var locationManager = CLLocationManager()
    @Published var position =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configuration.cameraImage = UIImage(named: "camera")
        configuration.flashOnImage = UIImage(named: "flash-on")
        configuration.galleryImage = UIImage(named: "photos")

        scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scanner!.delegate = self
        self.present(scanner!, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopUpdatingLocation()
    }
    
}

extension RollCallVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        let (code, eventId) = getCodeAndEventId(url: result)
        
        viewModel.rollCall(code: code, eventId: eventId, latitude: position.latitude, longitude: position.longitude)
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    self.showToast(message: "Diem danh thanh cong", state: .success)
                    self.popVC()
                    print("Success @@@@")
                case .Error(let error):
                    self.showToast(message: "Diem danh that bai", state: .error)
                    self.dismissVC()
                    print(error, "@@@@")
                }
            })
            .disposed(by: bag)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: SwiftQRScanner.QRCodeError) {
        showToast(message: "scan_error_title".localized, state: .error)
        self.dismissVC()
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        self.showToast(message: "cancel".localized, state: .warning)
    }
}

extension RollCallVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension RollCallVC {
    func getCodeAndEventId(url: String) -> (String, String){
        var code = ""
        var eventId = ""
        
        if let codeRange = url.range(of: "Code=([0-9a-fA-F-]+)", options: .regularExpression) {
            let codeValue = String(url[codeRange])
            if let codeSeparatorRange = codeValue.range(of: "=") {
                let extractedCode = codeValue[codeSeparatorRange.upperBound...]
                code = String(extractedCode)
            }
        }
        
        if let eventIdRange = url.range(of: "EventId=([0-9a-fA-F-]+)", options: .regularExpression) {
            let eventIdValue = String(url[eventIdRange])
            if let eventIdSeparatorRange = eventIdValue.range(of: "=") {
                let extractedEventId = eventIdValue[eventIdSeparatorRange.upperBound...]
                eventId = String(extractedEventId)
            }
        }
        
        return (code, eventId)
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
