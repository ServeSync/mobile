//
//  SeeProofDetailVC.swift
//  PBL6
//
//  Created by KietKoy on 02/01/2024.
//

import UIKit

class SeeProofDetailVC: BaseVC<SeeProofDetailVM> {
    
    @IBOutlet weak var typeProofTextField: UITextField!
    @IBOutlet weak var nameProofTextField: UITextField!
    @IBOutlet weak var eventActivitiesTextField: UITextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var attendanceTimeTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: ITextView!
    @IBOutlet weak var rejectReasonTextView: ITextView!
    
    @IBOutlet weak var proofImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var proofStatusLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rejectReasonView: UIView!
    
    @IBOutlet weak var proofStatusView: UIView!
    
    @IBOutlet weak var rejectReasonTextViewHC: NSLayoutConstraint!
    
    private lazy var textFields: [UITextField] = [
        typeProofTextField,
        nameProofTextField,
        eventActivitiesTextField,
        organizationNameTextField,
        addressTextField,
        startTimeTextField,
        endTimeTextField,
        attendanceTimeTextField,
        roleTextField,
        scoreTextField
    ]
    
    init(proofId: String) {
        super.init()
        
        viewModel.proofId = proofId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                        viewModel.messageData.accept(AlertMessage(type: .error, description: getErrorDescription(forErrorCode: error!.code)))
                    }
                }
                
            })
            .disposed(by: bag)
    }
    
    override func initViews() {
        super.initViews()
        
        for textField in textFields {
            textField.setLeftPaddingPoints(16)
            textField.setRightPaddingPoints(44)
            textField.isUserInteractionEnabled = false
        }
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12,
                                                              left: 16,
                                                              bottom: 12,
                                                              right: 16)
        rejectReasonTextView.textContainerInset = UIEdgeInsets(top: 12,
                                                              left: 16,
                                                              bottom: 12,
                                                              right: 16)
        descriptionTextView.isUserInteractionEnabled = false
        rejectReasonTextView.isUserInteractionEnabled = false
        
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
        contentView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 0), color: "#000000".toUIColor(alpha: 0.15))
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.proofItemData
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                updateView(with: item)
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

private extension SeeProofDetailVC {
    private func updateView(with item: ProofDetailDto) {
        switch item.proofStatus {
        case ProofStatus.Approved.rawValue:
            proofStatusLabel.text = "approved_proof".localized
            proofStatusView.backgroundColor = "#67DA64".toUIColor()
            rejectReasonTextViewHC.constant = 0
            rejectReasonView.gone()
        case ProofStatus.Pending.rawValue:
            proofStatusLabel.text = "pending_proof".localized
            proofStatusView.backgroundColor = "#F3DA65".toUIColor()
            rejectReasonTextViewHC.constant = 0
            rejectReasonView.gone()
        case ProofStatus.Rejected.rawValue:
            proofStatusLabel.text = "rejected_proof".localized
            proofStatusView.backgroundColor = "#F07C6A".toUIColor()
            rejectReasonTextView.text = item.rejectReason
        default:
            print("")
        }
        typeProofTextField.text = "\(item.proofType.lowercased())_proof".localized
        nameProofTextField.text = item.eventName
        eventActivitiesTextField.text = item.activity.name
        organizationNameTextField.text = item.organizationName
        addressTextField.text = item.address
        roleTextField.text = item.role
        scoreTextField.text = "\(item.score)"
        descriptionTextView.text = item.description
        
        var date = convertStringToDate(item.startAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        startTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
        
        date = convertStringToDate(item.endAt)
        date = date!.addingTimeInterval(7 * 60 * 60)
        endTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
        
        attendanceTimeTextField.text = convertDateFormat(item.attendanceAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
        loadImageFromURL(from: item.imageUrl, into: proofImage)
    }
}
