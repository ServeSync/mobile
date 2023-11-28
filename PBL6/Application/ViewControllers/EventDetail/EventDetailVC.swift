//
//  EventDetail1VC.swift
//  PBL6
//
//  Created by KietKoy on 19/11/2023.
//

import UIKit
import RxDataSources
import SwiftQRScanner
import CoreLocation
import AVFoundation

class EventDetailVC: BaseVC<EventDetailVM> {
    @IBOutlet weak var overviewScollView: UIScrollView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var overviewButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var representativeImage: UIImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var registeredQuantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameOrganizationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var eventStatusView: GradientView!
    
    @IBOutlet weak var roleCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var speakerCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var organizationCollectionView: IntrinsicCollectionView!

    @IBOutlet weak var roleCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var speakerCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var organizationalCollectionViewHC: NSLayoutConstraint!
    
    private var configuration = QRScannerConfiguration()
    private var scanner: QRCodeScannerController?
    private var locationManager = CLLocationManager()
    @Published var position =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    init(eventId: String) {
        super.init()
        viewModel.eventId = eventId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        roleCollectionViewHC.constant = roleCollectionView.intrinsicContentSize.height
        speakerCollectionViewHC.constant = speakerCollectionView.intrinsicContentSize.height
        organizationalCollectionViewHC.constant = organizationCollectionView.intrinsicContentSize.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error,
                                                                  description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
            })
            .disposed(by: bag)
        
        configuration.cameraImage = UIImage(named: "camera")
        configuration.flashOnImage = UIImage(named: "flash-on")
        configuration.galleryImage = UIImage(named: "photos")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func initViews() {
        super.initViews()
        
        handleNavButtonTap(showScrollView: overviewScollView,
                           hideScrollView: detailScrollView,
                           showButton: overviewButton,
                           hideButton: detailButton)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        detailButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                handleNavButtonTap(showScrollView: detailScrollView,
                                   hideScrollView: overviewScollView,
                                   showButton: detailButton,
                                   hideButton: overviewButton)
            })
            .disposed(by: bag)
        
        overviewButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                handleNavButtonTap(showScrollView: overviewScollView,
                                   hideScrollView: detailScrollView,
                                   showButton: overviewButton,
                                   hideButton: detailButton)
            })
            .disposed(by: bag)
        
        actionButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                switch viewModel.getButtonActionStatus() {
                case .complain:
                    print("")
                case .register:
                    let vc = RegisterVC(data: viewModel.eventDetailItem.roles)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.delegate = self
                    self.presentVC(vc)
                case .rollCall:
                    switch CLLocationManager().authorizationStatus {
                    case .notDetermined, .restricted, .denied:
                        PermissionHelper.shared.showSettingPermissionDialog(parentVC: self,
                                                                            title: "location_permission_is_not_granted_title".localized,
                                                                            message: "location_permission_is_not_granted_message".localized)
                    case .authorizedAlways, .authorizedWhenInUse:
                        scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
                        scanner?.delegate = self
                        self.presentVC(scanner!) {
                            switch AVCaptureDevice.authorizationStatus(for: .video) {
                            case .notDetermined, .restricted, .denied:
                                PermissionHelper.shared.showSettingPermissionDialog(parentVC: self.scanner!,
                                                                                    title: "camera_permission_is_not_granted_title".localized,
                                                                                    message: "camera_permission_is_not_granted_message".localized)
                            default:
                                break
                            }
                        }
                    @unknown default:
                        break
                    }
                default:
                    print("")
                }
                
            })
            .disposed(by: bag)
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                self.popVC()
            })
            .disposed(by: bag)
        
        favoriteButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                viewModel.favoriteEventChanged()
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.rolesDataS
            .map{ [SectionModel(model: (), items: $0)]}
            .bind(to: roleCollectionView.rx.items(dataSource: getRoleItemDataSource()))
            .disposed(by: bag)
        
        viewModel.eventDetailItemR
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                self.updateView(with: item)
            })
            .disposed(by: bag)
        
        viewModel.speakersDataS
            .map { [SectionModel(model: (), items: $0)]}
            .bind(to: speakerCollectionView.rx.items(dataSource: getSpeakerItemDataSource()))
            .disposed(by: bag)
        
        viewModel.organizationsDataS
            .map { [SectionModel(model: (), items: $0)]}
            .bind(to: organizationCollectionView.rx.items(dataSource: getOrganizationItemDataSource()))
            .disposed(by: bag)
        
        viewModel.messageData.asObservable()
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                AlertVC.showMessage(self, message: AlertMessage(type: alert.type,
                                                                description: alert.description)) {}
            })
            .disposed(by: bag)
    }
    
    override func configureListView() {
        super.configureListView()
        
        roleCollectionView.registerCellNib(RoleItemCell.self)
        let layouRoleCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 52/327, minimumLineSpacing: 8, scrollDirection: .vertical)
        roleCollectionView.collectionViewLayout = layouRoleCollectionView
        
        speakerCollectionView.registerCellNib(SpeakerItemCell.self)
        let layoutspeakerCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 48/327, minimumLineSpacing: 16, scrollDirection: .vertical)
        speakerCollectionView.collectionViewLayout = layoutspeakerCollectionView
        
        organizationCollectionView.registerCellNib(OrganizationItemCell.self)
        let layoutorganizationCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 104/327, minimumLineSpacing: 16, scrollDirection: .vertical)
        organizationCollectionView.collectionViewLayout = layoutorganizationCollectionView
    }
}

private extension EventDetailVC {
    private func updateView(with item: EventDetailDto) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            eventNameLabel.text = item.name
            eventTypeLabel.text = item.type.lowercased().localized
            introductionLabel.text = item.introduction
            eventStatusLabel.text = item.status.lowercased().localized
            numberOfPeopleLabel.text = "\(item.capacity) \("people".localized)"
            startTimeLabel.text = convertDateFormat(item.startAt)
            endTimeLabel.text = convertDateFormat(item.endAt)
            addressLabel.text = item.address.fullAddress
            registeredQuantityLabel.text = "\(item.registered)"
            
            eventImage.setImage(with: URL(string: item.imageUrl), placeholder: "img_event_thumb_default".toUIImage())
            
            nameOrganizationLabel.text = item.representativeOrganization.name
            
            if let data = item.description.data(using: .utf8) {
                do {
                    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                        .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue
                    ]
                    
                    let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                    let modifiedString = attributedString.string.replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    descriptionLabel.text = modifiedString
                } catch {
                    print("Error converting HTML to NSAttributedString: \(error)")
                    descriptionLabel.text = item.description
                }
            } else {
                descriptionLabel.text = item.description
            }
            
            nameOrganizationLabel.text = item.representativeOrganization.name
            positionLabel.text = item.representativeOrganization.address
            emailLabel.text = item.representativeOrganization.email
            phoneLabel.text = item.representativeOrganization.phoneNumber
            loadImageFromURL(from: item.representativeOrganization.imageUrl, into: representativeImage)
            favoriteIcon.isHighlighted = item.isFavorite
            updateStatusButton(item)
            updateActionButton(item)
        }
    }
    
    private func updateStatusButton(_ item: EventDetailDto) {
        eventStatusLabel.text = item.calculatedStatus.lowercased().localized
        switch item.calculatedStatus {
        case EventStatus.Done.rawValue:
            eventStatusView.startColor = "FFF09E".toUIColor()
            eventStatusView.endColor = "FFE55A".toUIColor()
        case EventStatus.Attendance.rawValue:
            eventStatusView.startColor = "56ECFF".toUIColor()
            eventStatusView.endColor = "58CCFE".toUIColor()
        case EventStatus.ClosedRegistration.rawValue:
            eventStatusView.startColor = "FFB2C5".toUIColor()
            eventStatusView.endColor = "FF8282".toUIColor()
        case EventStatus.Registration.rawValue:
            eventStatusView.startColor = "8DFF7A".toUIColor()
            eventStatusView.endColor = "00F335".toUIColor()
        case EventStatus.Approved.rawValue:
            eventStatusView.startColor = "E7E7E7".toUIColor()
            eventStatusView.endColor = "DCDCDC".toUIColor()
        default:
            eventStatusView.startColor = "EC9EFF".toUIColor()
            eventStatusView.endColor = "FC52FF".toUIColor()
        }
    }
    
    private func updateActionButton(_ item: EventDetailDto) {
        if item.isRegistered && item.isAttendance {
            actionButton.setTitle("complain".localized, for: .normal)
            actionButton.backgroundColor = "#FF745F".toUIColor()
            viewModel.updateButtonActionStatus(status: .complain)
        } else if item.isRegistered && item.calculatedStatus == EventStatus.Attendance.rawValue {
            actionButton.setTitle("roll_call".localized, for: .normal)
            actionButton.backgroundColor = "#26C6DA".toUIColor()
            viewModel.updateButtonActionStatus(status: .rollCall)
        } else if item.roles.contains(where: {$0.isRegistered == false}) && item.calculatedStatus == EventStatus.Registration.rawValue {
            actionButton.setTitle("register".localized, for: .normal)
            actionButton.backgroundColor = "#24B720".toUIColor()
            viewModel.updateButtonActionStatus(status: .register)
        } else {
            actionButton.isHidden = true
            actionButton.gone()
            viewModel.updateButtonActionStatus(status: .none)
        }
    }
    
    func handleNavButtonTap(showScrollView: UIScrollView, hideScrollView: UIScrollView, showButton: UIButton, hideButton: UIButton) {
        showScrollView.isHidden = false
        hideScrollView.isHidden = true
        let desiredOffset = CGPoint(x: 0, y: -showScrollView.contentInset.top)
        showScrollView.setContentOffset(desiredOffset, animated: true)
        
        showButton.borders(for: [.bottom], color: "#195E8E".toUIColor())
        showButton.setTitleColor("#195E8E".toUIColor(), for: .normal)
        hideButton.borders(for: [.bottom], color: .clear)
        hideButton.setTitleColor("#A0A2A4".toUIColor(), for: .normal)
    }
}

extension EventDetailVC: RegisterEventDelegate {
    func updateRoleRegister(roleId: String) {
        self.showToast(message: "register_success".localized, state: .success)
        viewModel.updateRoleRegister(roleId: roleId)
        if !viewModel.eventDetailItem.roles.contains(where: { $0.isRegistered == false}) {
            print("###")
            actionButton.gone()
        }
    }
}

extension EventDetailVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            scanner?.delegate = nil
            scanner = nil
        }
        
        let (code, eventId) = getCodeAndEventId(url: result)
        
        viewModel.rollCall(code: code, eventId: eventId, latitude: position.latitude, longitude: position.longitude)
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                switch status {
                case .Success:
                    DispatchQueue.main.async {
                        self.showToast(message: "roll_call_success".localized, state: .success)
//                        self.actionButtonHC.constant = 0
                        self.view.layoutIfNeeded()
                    }
                case .Error(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        if error?.code == Configs.Server.errorCodeRequiresLogin {
                            AppDelegate.shared().windowMainConfig(vc: LoginVC())
                        } else {
                            self.showToast(message: getErrorDescription(forErrorCode: error!.code), state: .error)
                        }
                    }
                }
            })
            .disposed(by: bag)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: SwiftQRScanner.QRCodeError) {
        
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        
    }
}

extension EventDetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension EventDetailVC {
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
