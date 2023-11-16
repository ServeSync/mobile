//
//  EventDetailVC.swift
//  PBL6
//
//  Created by KietKoy on 13/10/2023.
//

import UIKit
import RxDataSources
import SwiftQRScanner
import CoreLocation

class EventDetailVC: BaseVC<EventDetailVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var representativeImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var typeEventLabel: UILabel!
    @IBOutlet weak var statusEventLabel: UILabel!
    @IBOutlet weak var registeredQuantityLabel: UILabel!
    
    @IBOutlet weak var statusEventView: GradientView!
    @IBOutlet weak var generalInforButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndStart: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var speakerCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var speakerCollectionViewHC: NSLayoutConstraint!
    @IBOutlet weak var roleCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var roleCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var organizationalCollectionView: IntrinsicCollectionView!
    @IBOutlet weak var organizationalCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var nameOrganizationLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var contentViewHC: NSLayoutConstraint!
    @IBOutlet weak var actionButtonHC: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var configuration = QRScannerConfiguration()
    private var scanner: QRCodeScannerController?
    private var locationManager = CLLocationManager()
    @Published var position =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
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
        organizationalCollectionViewHC.constant = organizationalCollectionView.intrinsicContentSize.height
    }
    
    override func initViews() {
        super.initViews()
        
        
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generalView.isHidden = false
        detailView.isHidden = true
        startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.contentViewHC.constant = self.actionButton.frame.height + 72 + self.generalView.frame.height
        self.contentView.setNeedsLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopUpdatingLocation()
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        detailButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                detailButton.setTitleColor("195E8E".toUIColor(), for: .normal)
                generalInforButton.setTitleColor("A0A2A4".toUIColor(), for: .normal)
                
                let contentOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                self.scrollView.setContentOffset(contentOffset, animated: false)
                self.detailView.isHidden = false
                self.generalView.isHidden = true
                self.contentViewHC.constant = self.actionButton.frame.height + 72 + self.detailView.frame.height
                
                print(self.contentViewHC.constant, "hihi")
            })
            .disposed(by: bag)
        
        generalInforButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                generalView.isHidden = false
                detailView.isHidden = true
                contentViewHC.constant = actionButton.frame.height + 72 + generalView.frame.height
                
                generalInforButton.setTitleColor("195E8E".toUIColor(), for: .normal)
                detailButton.setTitleColor("A0A2A4".toUIColor(), for: .normal)
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
                        self.presentVC(scanner!)
                    @unknown default:
                        break
                    }
                default:
                    print("")
                }
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
            .bind(to: organizationalCollectionView.rx.items(dataSource: getOrganizationItemDataSource()))
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
        
        organizationalCollectionView.registerCellNib(OrganizationItemCell.self)
        let layoutorganizationCollectionView = ColumnFlowLayout(cellsPerRow: 1, ratio: 104/327, minimumLineSpacing: 16, scrollDirection: .vertical)
        organizationalCollectionView.collectionViewLayout = layoutorganizationCollectionView
    }
}

private extension EventDetailVC {
    private func updateView(with item: EventDetailDto) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            eventNameLabel.text = item.name
            typeEventLabel.text = item.type.lowercased().localized
            introductionLabel.text = item.introduction
            statusEventLabel.text = item.status.lowercased().localized
            capacityLabel.text = "\(item.capacity) \("people".localized)"
            timeStartLabel.text = convertDateFormat(item.startAt)
            timeEndStart.text = convertDateFormat(item.endAt)
            placeLabel.text = item.address.fullAddress
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
            favoriteImage.isHighlighted = item.isFavorite
            updateStatusButton(item)
            updateActionButton(item)
        }
    }
    
    private func updateStatusButton(_ item: EventDetailDto) {
        statusEventLabel.text = item.calculatedStatus.lowercased().localized
        switch item.calculatedStatus {
        case EventStatus.Done.rawValue:
            statusEventView.startColor = "FFF09E".toUIColor()
            statusEventView.endColor = "FFE55A".toUIColor()
        case EventStatus.Attendance.rawValue:
            statusEventView.startColor = "56ECFF".toUIColor()
            statusEventView.endColor = "58CCFE".toUIColor()
        case EventStatus.ClosedRegistration.rawValue:
            statusEventView.startColor = "FFB2C5".toUIColor()
            statusEventView.endColor = "FF8282".toUIColor()
        case EventStatus.Registration.rawValue:
            statusEventView.startColor = "8DFF7A".toUIColor()
            statusEventView.endColor = "00F335".toUIColor()
        case EventStatus.Approved.rawValue:
            statusEventView.startColor = "E7E7E7".toUIColor()
            statusEventView.endColor = "DCDCDC".toUIColor()
        default:
            statusEventView.startColor = "EC9EFF".toUIColor()
            statusEventView.endColor = "FC52FF".toUIColor()
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
        } else if !item.isRegistered && item.calculatedStatus == EventStatus.Registration.rawValue {
            actionButton.setTitle("register".localized, for: .normal)
            actionButton.backgroundColor = "#24B720".toUIColor()
            viewModel.updateButtonActionStatus(status: .register)
        } else {
            actionButton.isHidden = true
            actionButtonHC.constant = 0
            viewModel.updateButtonActionStatus(status: .none)
        }
    }
}


extension EventDetailVC: RegisterEventDelegate {
    func updateRoleRegister(roleId: String) {
        self.showToast(message: "register_success".localized, state: .success)
        viewModel.updateRoleRegister(roleId: roleId)
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
                        self.actionButtonHC.constant = 0
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
