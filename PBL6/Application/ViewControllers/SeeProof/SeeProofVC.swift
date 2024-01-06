//
//  SeeProofVC.swift
//  PBL6
//
//  Created by KietKoy on 09/12/2023.
//

import UIKit

class SeeProofVC: BaseVC<SeeProofVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var organizationNameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var attendanceTimeView: UIView!
    @IBOutlet weak var proofStatusView: UIView!
    
    @IBOutlet weak var proofTypeTextField: UITextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventActivitiesTextField: UITextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var attendanceTimeTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: ITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var proofStatusLabel: UILabel!
    @IBOutlet weak var proofImage: UIImageView!
    
    @IBOutlet weak var organizationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeAttendanceBottomConstraint: NSLayoutConstraint!
    
    private lazy var textFields: [UITextField] = [
        proofTypeTextField,
        eventNameTextField,
        organizationNameTextField,
        addressTextField,
        startTimeTextField,
        endTimeTextField,
        attendanceTimeTextField,
        roleTextField,
        scoreTextField,
        eventActivitiesTextField
    ]
    
    init(id: String) {
        super.init()
        viewModel.idProof = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        super.initViews()
        
        setPaddingTextField()
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
        contentView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 0), color: "#000000".toUIColor(alpha: 0.15))
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
                    viewModel.messageData.accept(AlertMessage(type: .error,
                                                              description: getErrorDescription(forErrorCode: error!.code)))
                }
            })
            .disposed(by: bag)
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.proofDetailData
            .subscribe(onNext: {[weak self] proofDetail in
                guard let self = self else { return }
                self.updateView(with: proofDetail)
            })
            .disposed(by: bag)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
    }
}

extension SeeProofVC {
    private func setPaddingTextField() {
        for textField in textFields {
            textField.setLeftPaddingPoints(16)
            textField.setRightPaddingPoints(44)
            textField.isEnabled = false
        }
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12,
                                                              left: 16,
                                                              bottom: 12,
                                                              right: 16)
        descriptionTextView.isEditable = false
    }
    
    private func updateView(with proofDetail: ProofDetailDto) {
        if proofDetail.proofType == ProofType.Special.rawValue {
            organizationNameView.gone()
            addressView.gone()
            attendanceTimeView.gone()
            
            organizationViewBottomConstraint.constant = 0
            addressViewBottomConstraint.constant = 0
            timeAttendanceBottomConstraint.constant = 0
        }
        proofTypeTextField.text = "\(proofDetail.proofType.lowercased())_proof".localized
        eventNameTextField.text = proofDetail.eventName
        eventActivitiesTextField.text = proofDetail.activity.name
        organizationNameTextField.text = proofDetail.organizationName
        addressTextField.text = proofDetail.address
        startTimeTextField.text = convertDateFormat(proofDetail.startAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
        endTimeTextField.text = convertDateFormat(proofDetail.endAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
        attendanceTimeTextField.text = convertDateFormat(proofDetail.attendanceAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
        roleTextField.text = proofDetail.role
        descriptionTextView.text = proofDetail.description
        scoreTextField.text = "\(Int(proofDetail.score)) điểm"
        loadImageFromURL(from: proofDetail.imageUrl, into: proofImage)
        proofStatusLabel.text = "\(proofDetail.proofStatus.lowercased())_proof".localized
        switch proofDetail.proofStatus {
        case ProofStatus.Pending.rawValue:
            proofStatusView.backgroundColor = "#F3DA65".toUIColor()
        case ProofStatus.Rejected.rawValue:
            proofStatusView.backgroundColor = "#F07C6A".toUIColor()
        default:
            proofStatusView.backgroundColor = "#67DA64".toUIColor()
        }
    }
}
