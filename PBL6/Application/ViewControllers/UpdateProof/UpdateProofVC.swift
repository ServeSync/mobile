//
//  UpdateProofVC.swift
//  PBL6
//
//  Created by KietKoy on 25/12/2023.
//

import UIKit
import SearchTextField

protocol UpdateProofDelegate: AnyObject {
    func updateProofSucces()
}

class UpdateProofVC: BaseVC<UpdateProofVM> {
    @IBOutlet weak var proofNameTextField: SearchTextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var attendanceTimeTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var descriptionTextView: ITextView!
    @IBOutlet weak var eventActivitiesTextField: SearchTextField!
    
    @IBOutlet weak var proofImage: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pickProofImageButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var organizationNameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var attendanceTimeView: UIView!
    
    @IBOutlet weak var nameProofLabel: UILabel!
    
    @IBOutlet weak var eventActivitiesBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var organizationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeAttendanceBottomConstraint: NSLayoutConstraint!
    
    private var activeTextField : UITextField? = nil
    private var imagePicker: UIImagePickerController? = nil
    private var proofType: ProofType = .External
    var delegate: UpdateProofDelegate?
    
    private lazy var textFields: [UITextField] = [
        proofNameTextField,
        organizationNameTextField,
        addressTextField,
        startTimeTextField,
        endTimeTextField,
        attendanceTimeTextField,
        roleTextField,
        scoreTextField,
        eventActivitiesTextField
    ]
    
    init(proofId: String, proofType: ProofType) {
        super.init()
        
        viewModel.proofId = proofId
        self.proofType = proofType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        super.initViews()
        
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
        contentView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 0), color: "#000000".toUIColor(alpha: 0.15))
        configureEventTypeTextField()
        setPaddingTextField()
        scoreTextField.keyboardType = .numberPad
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        viewModel.fetchData()
            .subscribe(onNext: {[weak self] status in
                guard let self = self else { return }
                makeDatePickerForAttendanceTime()
                makeDatePickerForStartTime()
                makeDatePickerForEndTime()
                switch status {
                case .Success:
                    return
                case .Error(let error):
                    if error?.code == Configs.Server.errorCodeRequiresLogin {
                        AppDelegate.shared().windowMainConfig(vc: LoginVC())
                    } else {
                        viewModel.messageData.accept(AlertMessage(type: .error,
                                                                  description: getErrorDescription(forErrorCode: error!.code)
                                                                 ))
                    }
                }
            })
            .disposed(by: bag)
        
        switch self.proofType {
        case .Internal:
            viewModel.getRegisteredStudentInEvent()
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
        case .External:
            viewModel.getEventActivities(type: .Event)
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
        case .Special:
            viewModel.getEventActivities(type: .Individual)
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
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        eventActivitiesTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return}
            let item = filteredResults[itemPosition]
            self.eventActivitiesTextField.text = item.title
            let minScore = viewModel.getEventActivities(by: itemPosition).minScore
            let maxScore = viewModel.getEventActivities(by: itemPosition).maxScore
            self.scoreTextField.placeholder = "\(Int(minScore)) - \(Int(maxScore)) điểm"
            view.endEditing(true)
        }
        
        proofNameTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            self.updateViewWhenCreated(isInternalProof: true,
                                       event: viewModel.getEvent(by: itemPosition))
            self.proofNameTextField.text = item.title
            view.endEditing(true)
        }
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.popVC()
            })
            .disposed(by: bag)
        
        pickProofImageButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                imagePicker = UIImagePickerController()
                imagePicker!.delegate = self
                imagePicker!.sourceType = .photoLibrary
                self.presentVC(imagePicker!)
            })
            .disposed(by: bag)
        
        updateButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                guard proofNameTextField.text?.isNotEmpty == true else {
                    viewModel.messageData.accept(AlertMessage(type: .error, description: "event_name_not_selectd_warning".localized))
                    return
                }
                
                if proofType == .Internal {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
                    
//                    guard !viewModel.attendanceTime!.isBeforeDate(dateFormatter.date(from: startTimeTextField.text!)!)
//                            && !viewModel.attendanceTime!.isAfterDate(dateFormatter.date(from: endTimeTextField.text!)!) else {
//                        viewModel.messageData.accept(AlertMessage(type: .error, description: "attendance_time_not_match_warning".localized))
//                        return
//                    }
                    guard !viewModel.attendanceTime!.isBeforeDate(viewModel.startTime!)
                            && !viewModel.attendanceTime!.isAfterDate(viewModel.endTime!) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "attendance_time_not_match_warning".localized))
                        return
                    }
                    
                    
                    guard descriptionTextView.text.isNotEmpty else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "description_empty_warning".localized))
                        return
                    }
                    
                    guard proofImage.image != nil else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "proof_image_not_choose".localized))
                        return
                    }
                    
                    viewModel.handleUpdateInternalProof(description: descriptionTextView.text)
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                self.popVC()
                                self.delegate?.updateProofSucces()
                                return
                            case .Error(let error):
                                viewModel.messageData.accept(AlertMessage(type: .error,
                                                                          description: getErrorDescription(forErrorCode: error!.code)))
                            }
                        })
                        .disposed(by: bag)
                } else if proofType == .External {
                    if viewModel.eventActivity == nil {
                        viewModel.eventActivity = viewModel.getEventActivities(by: viewModel.proofItem!.activity.id)
                    }
                    guard eventActivitiesTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "activity_empty_warning".localized))
                        return
                    }
                    
                    guard organizationNameTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "organizationName_empty_warning".localized))
                        return
                    }
                    
                    guard addressTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "address_empty_warning".localized))
                        return
                    }
                    
                    guard addressTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "address_empty_warning".localized))
                        return
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
                    
                    guard !dateFormatter.date(from: self.startTimeTextField.text!)!.isAfterDate(Date()) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "start_time_not_match_warning".localized))
                        return
                    }
                    
                    guard !dateFormatter.date(from: self.endTimeTextField.text!)!.isAfterDate(Date()) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "end_time_not_match_warning".localized))
                        return
                    }
                    
                    guard !dateFormatter.date(from: self.startTimeTextField.text!)!.isAfterDate(dateFormatter.date(from: self.endTimeTextField.text!)!) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "start_and_end_time_not_match_warning".localized))
                        return
                    }
                    
                    guard !viewModel.attendanceTime!.isBeforeDate(dateFormatter.date(from: startTimeTextField.text!)!)
                            && !viewModel.attendanceTime!.isAfterDate(dateFormatter.date(from: endTimeTextField.text!)!) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "attendance_time_not_match_warning".localized))
                        return
                    }
                    
                    guard roleTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "role_empty_warning".localized))
                        return
                    }
                    
                    guard scoreTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "score_empty_warning".localized))
                        return
                    }
                    
                    guard scoreTextField.text!.toDouble! >= viewModel.eventActivity!.minScore && scoreTextField.text!.toDouble! <= viewModel.eventActivity!.maxScore else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "score_not_match_warning".localized))
                        return
                    }
                    
                    guard descriptionTextView.text.isNotEmpty else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "description_empty_warning".localized))
                        return
                    }
                    
                    guard proofImage.image != nil else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "proof_image_not_choose".localized))
                        return
                    }
                    
                    viewModel.handleUpdateExternalProof(eventName: proofNameTextField.text!,
                                                        address: addressTextField.text!,
                                                        organizationName: organizationNameTextField.text!,
                                                        role: roleTextField.text!,
                                                        score: scoreTextField.text!.toDouble!,
                                                        description: descriptionTextView.text)
                    .subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            self.popVC()
                            self.delegate?.updateProofSucces()
                            return
                        case .Error(let error):
                            viewModel.messageData.accept(AlertMessage(type: .error,
                                                                      description: getErrorDescription(forErrorCode: error!.code)))
                        }
                    })
                    .disposed(by: bag)
                } else {
                    if viewModel.eventActivity == nil {
                        viewModel.eventActivity = viewModel.getEventActivities(by: viewModel.proofItem!.activity.id)
                    }
                    
                    guard eventActivitiesTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "activity_empty_warning".localized))
                        return
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
                    
                    guard !dateFormatter.date(from: self.startTimeTextField.text!)!.isAfterDate(Date()) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "start_time_not_match_warning".localized))
                        return
                    }
                    
                    guard !dateFormatter.date(from: self.endTimeTextField.text!)!.isAfterDate(Date()) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "end_time_not_match_warning".localized))
                        return
                    }
                    
                    guard !dateFormatter.date(from: self.startTimeTextField.text!)!.isAfterDate(dateFormatter.date(from: self.endTimeTextField.text!)!) else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "start_and_end_time_not_match_warning".localized))
                        return
                    }
                    
                    guard roleTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "role_empty_warning".localized))
                        return
                    }
                    
                    guard scoreTextField.text?.isNotEmpty == true else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "score_empty_warning".localized))
                        return
                    }
                    
                    guard scoreTextField.text!.toDouble! >= viewModel.eventActivity!.minScore && scoreTextField.text!.toDouble! <= viewModel.eventActivity!.maxScore else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "score_not_match_warning".localized))
                        return
                    }
                    
                    guard descriptionTextView.text.isNotEmpty else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "description_empty_warning".localized))
                        return
                    }
                    
                    guard proofImage.image != nil else {
                        viewModel.messageData.accept(AlertMessage(type: .error, description: "proof_image_not_choose".localized))
                        return
                    }
                    
                    viewModel.handleUpdateSpecialProof(title: proofNameTextField.text!,
                                                       role: roleTextField.text!,
                                                       score: scoreTextField.text!.toDouble!,
                                                       description: descriptionTextView.text)
                    .subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            self.popVC()
                            self.delegate?.updateProofSucces()
                            return
                        case .Error(let error):
                            viewModel.messageData.accept(AlertMessage(type: .error,
                                                                      description: getErrorDescription(forErrorCode: error!.code)))
                        }
                    })
                    .disposed(by: bag)
                }
            })
            .disposed(by: bag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.registeredStudentInEventData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                proofNameTextField.filterStrings(data.map{$0.name})
            })
            .disposed(by: bag)
        
        viewModel.eventActivitiestData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                eventActivitiesTextField.filterStrings(data.map{$0.name})
            })
            .disposed(by: bag)
        
        viewModel.proofItemData
            .subscribe(onNext: {[weak self] item in
                guard let self = self else { return }
                switch self.proofType {
                case .Internal:
                    self.updateView(with: item)
                case .External:
                    self.updateView(with: item)
                case .Special:
                    self.updateView(with: item)
                }
            })
            .disposed(by: bag)
        
        viewModel.registeredStudentInEventData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                proofNameTextField.filterStrings(data.map{$0.name})
            })
            .disposed(by: bag)
        
        viewModel.eventActivitiestData
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                eventActivitiesTextField.filterStrings(data.map{$0.name})
            })
            .disposed(by: bag)
    }
    
    @objc override func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    @objc override func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func handleTap() {
        if let activeTextField = activeTextField {
            activeTextField.resignFirstResponder()
        }
        descriptionTextView.resignFirstResponder()
    }
}

private extension UpdateProofVC {
    private func configureEventTypeTextField() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            proofNameTextField.theme.cellHeight = 50
            proofNameTextField.startVisible = true
            proofNameTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            proofNameTextField.theme.bgColor = .white
            
            eventActivitiesTextField.theme.cellHeight = 50
            eventActivitiesTextField.startVisible = true
            eventActivitiesTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            eventActivitiesTextField.theme.bgColor = .white
        }
    }
    
    private func setPaddingTextField() {
        for textField in textFields {
            textField.setLeftPaddingPoints(16)
            textField.setRightPaddingPoints(44)
            textField.delegate = self
        }
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12,
                                                              left: 16,
                                                              bottom: 12,
                                                              right: 16)
        descriptionTextView.delegate = self
    }
    
    private func makeDatePickerForAttendanceTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 150))
        let datePicker = UIDatePicker(frame: CGRect(x: inputView.frame.width/4, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        if self.proofType != .Special {
            datePicker.date = viewModel.attendanceTime!
        }
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePickerForAttendanceTime(sender:)), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor("#049300".toUIColor(), for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButtonAttendanceTime(sender:)), for: .touchUpInside)
        
        handleDatePickerForAttendanceTime(sender: datePicker)
        
        attendanceTimeTextField.inputView = inputView
    }
    
    private func makeDatePickerForStartTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 150))
        let datePicker = UIDatePicker(frame: CGRect(x: inputView.frame.width/4, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = viewModel.startTime!
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePickerForStartTime(sender:)), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor("#049300".toUIColor(), for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButtonStartTime(sender:)), for: .touchUpInside)
        
        handleDatePickerForStartTime(sender: datePicker)
        
        startTimeTextField.inputView = inputView
    }
    
    private func makeDatePickerForEndTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 150))
        let datePicker = UIDatePicker(frame: CGRect(x: inputView.frame.width/4, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = viewModel.endTime!
        inputView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePickerForEndTime(sender:)), for: .valueChanged)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor("#049300".toUIColor(), for: .normal)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButtonEndTime(sender:)), for: .touchUpInside)
        
        handleDatePickerForEndTime(sender: datePicker)
        
        endTimeTextField.inputView = inputView
    }
    
    @objc func handleDatePickerForAttendanceTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        attendanceTimeTextField.text = formatter.string(from: sender.date)
        viewModel.attendanceTime = sender.date
    }
    
    @objc func handleDoneButtonAttendanceTime(sender: UIButton) {
        attendanceTimeTextField.resignFirstResponder()
    }
    
    @objc func handleDatePickerForStartTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        startTimeTextField.text = formatter.string(from: sender.date)
        viewModel.startTime = sender.date
    }
    
    @objc func handleDoneButtonStartTime(sender: UIButton) {
        startTimeTextField.resignFirstResponder()
    }
    
    @objc func handleDatePickerForEndTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        endTimeTextField.text = formatter.string(from: sender.date)
        viewModel.endTime = sender.date
    }
    
    @objc func handleDoneButtonEndTime(sender: UIButton) {
        endTimeTextField.resignFirstResponder()
    }
    
    private func updateView(with item: ProofDetailDto) {
        proofNameTextField.text = item.eventName
        eventActivitiesTextField.text = item.activity.name
        organizationNameTextField.text = item.organizationName
        addressTextField.text = item.address
        roleTextField.text = item.role
        scoreTextField.text = "\(item.score)"
        descriptionTextView.text = item.description
        
        attendanceTimeTextField.text = convertDateFormat(item.attendanceAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
        proofImage.setImage(with: URL(string: item.imageUrl), onSuccess: {[weak self] in
            guard let self = self else { return }
            viewModel.proofImage = proofImage.image
        })
        
        
        switch self.proofType {
        case .External:
            var date = convertStringToDate(item.startAt)
            date = date!.addingTimeInterval(7 * 60 * 60)
            startTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            date = convertStringToDate(item.endAt)
            date = date!.addingTimeInterval(7 * 60 * 60)
            endTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            viewModel.attendanceTime = convertStringToDate(item.attendanceAt)
            viewModel.startTime = convertStringToDate(item.startAt)?.addingTimeInterval(7 * 60 * 60)
            viewModel.endTime = convertStringToDate(item.endAt)?.addingTimeInterval(7 * 60 * 60)
        case .Internal:
            organizationNameTextField.isEnabled = false
            addressTextField.isEnabled = false
            startTimeTextField.isEnabled = false
            endTimeTextField.isEnabled = false
            roleTextField.isEnabled = false
            scoreTextField.isEnabled = false
            eventActivitiesTextField.isEnabled = false
            
            var date = convertStringToDate(item.startAt)
            date = date!.addingTimeInterval(7 * 60 * 60)
            startTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            date = convertStringToDate(item.endAt)
            date = date!.addingTimeInterval(7 * 60 * 60)
            endTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            viewModel.attendanceTime = convertStringToDate(item.attendanceAt)
            viewModel.startTime = convertStringToDate(item.startAt)?.addingTimeInterval(7 * 60 * 60)
            viewModel.endTime = convertStringToDate(item.endAt)?.addingTimeInterval(7 * 60 * 60)
        case .Special:
            organizationNameView.gone()
            addressView.gone()
            attendanceTimeView.gone()
            organizationViewBottomConstraint.constant = 0
            addressViewBottomConstraint.constant = 0
            timeAttendanceBottomConstraint.constant = 0
            nameProofLabel.text = "proof_name".localized
            var date = convertStringToDate(item.startAt)
            startTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            date = convertStringToDate(item.endAt)
            endTimeTextField.text = FormatUtils.formatDateToString(date!, formatterString: "HH:mm dd/MM/yyyy")
            
            viewModel.attendanceTime = convertStringToDate(item.attendanceAt)
            viewModel.startTime = convertStringToDate(item.startAt)
            viewModel.endTime = convertStringToDate(item.endAt)
        }
        
        for textField in textFields {
            textField.backgroundColor = textField.isEnabled ? .white : "#EAEAEA".toUIColor()
        }
    }
    
    private func updateViewWhenCreated(isInternalProof: Bool, event: StudentRegisteredEventDto = StudentRegisteredEventDto()) {
        if isInternalProof {
            organizationNameTextField.text = event.representativeOrganization.name
            addressTextField.text = event.address.fullAddress
            startTimeTextField.text = convertDateFormat(event.startAt, dateNeedFormat: "HH:mm dd/MM/yyyy")
            endTimeTextField.text = convertDateFormat(event.endAt, dateNeedFormat: "HH:mm dd/MM/yyyy")
            roleTextField.text = event.role
            scoreTextField.text = "\(event.score)"
            eventActivitiesTextField.text = event.activity.name
            
            organizationNameTextField.isEnabled = false
            addressTextField.isEnabled = false
            startTimeTextField.isEnabled = false
            endTimeTextField.isEnabled = false
            roleTextField.isEnabled = false
            scoreTextField.isEnabled = false
            eventActivitiesTextField.isEnabled = false
        } else {
            makeDatePickerForEndTime()
            makeDatePickerForStartTime()
            organizationNameTextField.isEnabled = true
            addressTextField.isEnabled = true
            startTimeTextField.isEnabled = true
            endTimeTextField.isEnabled = true
            roleTextField.isEnabled = true
            scoreTextField.isEnabled = true
            eventActivitiesTextField.isEnabled = true
        }
        
        for textField in textFields {
            textField.backgroundColor = textField.isEnabled ? .white : "#EAEAEA".toUIColor()
        }
    }
}

extension UpdateProofVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            proofImage.image = selectedImage
            viewModel.proofImage = selectedImage
            imagePicker?.dismiss(animated: true)
        }
    }
}

extension UpdateProofVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
}

extension UpdateProofVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
