//
//  CreateProofVC.swift
//  PBL6
//
//  Created by KietKoy on 30/11/2023.
//

import UIKit
import SearchTextField
import DropDown

protocol CreateProofDelegate: AnyObject {
    func createProofSucces()
}

class CreateProofVC: BaseVC<CreateProofVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uploadProofView: UIView!
    @IBOutlet weak var eventActivitiesView: UIView!
    @IBOutlet weak var organizationNameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var attendanceTimeView: UIView!
    
    @IBOutlet weak var proofTypeTextField: SearchTextField!
    @IBOutlet weak var eventNameTextField: SearchTextField!
    @IBOutlet weak var eventActivitiesTextField: SearchTextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var attendanceTimeTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: ITextView!
    
    @IBOutlet weak var proofImage: UIImageView!
    
    @IBOutlet weak var chooseProofImagaButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameProofLabel: UILabel!
    
    @IBOutlet weak var eventActivitiesBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var organizationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeAttendanceBottomConstraint: NSLayoutConstraint!
    
    private var imagePicker: UIImagePickerController? = nil
    
    var delegate: CreateProofDelegate?
    private var proofTypePositionSelected: Int?
    private var proofType: ProofType?
    
    private var activeTextField : UITextField? = nil
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func initViews() {
        super.initViews()
        
        contentView.roundDifferentCorners(topLeft: 24, topRight: 24)
        contentView.addDropShadow(shadowRadius: 4, offset: CGSize(width: 0, height: 0), color: "#000000".toUIColor(alpha: 0.15))
        uploadProofView.addDashedBorder("#26C6DA".toUIColor(), cornerRadius: 11)
        configureEventTypeTextField()
        setPaddingTextField()
        makeDatePickerForAttendanceTime()
        makeDatePickerForStartTime()
        makeDatePickerForEndTime()
        scoreTextField.keyboardType = .numberPad
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        proofTypeTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            
            if itemPosition == 0 {
                proofType = .Internal
                nameProofLabel.text = "event_name".localized
                
                organizationNameView.visible()
                addressView.visible()
                attendanceTimeView.visible()
                organizationViewBottomConstraint.constant = 20
                addressViewBottomConstraint.constant = 20
                timeAttendanceBottomConstraint.constant = 20
                
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
            } else if itemPosition == 1 {
                self.updateView(isInternalProof: false)
                proofType = .External
                eventNameTextField.filterStrings([])
                nameProofLabel.text = "event_name".localized
                
                organizationNameView.visible()
                addressView.visible()
                attendanceTimeView.visible()
                organizationViewBottomConstraint.constant = 20
                addressViewBottomConstraint.constant = 20
                timeAttendanceBottomConstraint.constant = 20
                
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
            } else {
                self.updateView(isInternalProof: false)
                proofType = .Special
                eventNameTextField.filterStrings([])
                nameProofLabel.text = "proof_name".localized
                
                organizationNameView.gone()
                addressView.gone()
                attendanceTimeView.gone()
                organizationViewBottomConstraint.constant = 0
                addressViewBottomConstraint.constant = 0
                timeAttendanceBottomConstraint.constant = 0
                
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
            self.proofTypeTextField.text = item.title
            
            if proofTypePositionSelected != itemPosition {
                for textField in textFields {
                    if textField != textFields.first
                        && textField != startTimeTextField
                        && textField != endTimeTextField
                        && textField != attendanceTimeTextField {
                        textField.text = ""
                    }
                }
                proofImage.image = nil
                proofTypePositionSelected = itemPosition
            }
            view.endEditing(true)
        }
        
        proofTypeTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                if !viewModel.typeEvent.contains(self.proofTypeTextField.text!) {
                    self.proofTypeTextField.text = ""
                }
            })
            .disposed(by: bag)
        
        eventNameTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            self.updateView(isInternalProof: true, event: viewModel.getEvent(by: itemPosition))
            self.eventNameTextField.text = item.title
            view.endEditing(true)
        }
        
        eventNameTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {[weak self] in
                guard let self else { return }
                if proofType == .Internal {
                    let eventName = self.eventNameTextField.text!
                    if !viewModel.isContaintEvent(with: eventName) {
                        eventNameTextField.text = ""
                    }
                }
            })
            .disposed(by: bag)
        
        eventActivitiesTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return}
            let item = filteredResults[itemPosition]
            self.eventActivitiesTextField.text = item.title
            let minScore = viewModel.getEventActivities(by: itemPosition).minScore
            let maxScore = viewModel.getEventActivities(by: itemPosition).maxScore
            self.scoreTextField.placeholder = "\(Int(minScore)) - \(Int(maxScore)) điểm"
            view.endEditing(true)
        }
        
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        chooseProofImagaButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                imagePicker = UIImagePickerController()
                imagePicker!.delegate = self
                imagePicker!.sourceType = .photoLibrary
                self.presentVC(imagePicker!)
            })
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                
                guard proofTypeTextField.text?.isNotEmpty == true else {
                    viewModel.messageData.accept(AlertMessage(type: .error, description: "proof_type_not_selected_warning".localized))
                    return
                }
                
                guard eventNameTextField.text?.isNotEmpty == true else {
                    viewModel.messageData.accept(AlertMessage(type: .error, description: "event_name_not_selectd_warning".localized))
                    return
                }
                
                if proofType == .Internal {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
                    
                    guard !viewModel.attendanceTime!.isBeforeDate(dateFormatter.date(from: startTimeTextField.text!)!) 
                            && !viewModel.attendanceTime!.isAfterDate(dateFormatter.date(from: endTimeTextField.text!)!) else {
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
                    
                    viewModel.handleCreateInternalProof(description: descriptionTextView.text)
                        .subscribe(onNext: {[weak self] status in
                            guard let self = self else { return }
                            switch status {
                            case .Success:
                                self.popVC()
                                self.delegate?.createProofSucces()
                                return
                            case .Error(let error):
                                viewModel.messageData.accept(AlertMessage(type: .error,
                                                                          description: getErrorDescription(forErrorCode: error!.code)))
                            }
                        })
                        .disposed(by: bag)
                } else if proofType == .External {
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
                    
                    viewModel.handleCreateExternalProof(eventName: eventNameTextField.text!,
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
                            self.delegate?.createProofSucces()
                            return
                        case .Error(let error):
                            viewModel.messageData.accept(AlertMessage(type: .error,
                                                                      description: getErrorDescription(forErrorCode: error!.code)))
                        }
                    })
                    .disposed(by: bag)
                } else {
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
                    
                    viewModel.handleCreateSpecialProof(title: eventNameTextField.text!,
                                                       role: roleTextField.text!,
                                                       score: scoreTextField.text!.toDouble!,
                                                       description: descriptionTextView.text)
                    .subscribe(onNext: {[weak self] status in
                        guard let self = self else { return }
                        switch status {
                        case .Success:
                            self.popVC()
                            self.delegate?.createProofSucces()
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
                eventNameTextField.filterStrings(data.map{$0.name})
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

extension CreateProofVC {
    private func configureEventTypeTextField() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            proofTypeTextField.filterStrings(viewModel.typeEvent)
            proofTypeTextField.theme.cellHeight = 50
            proofTypeTextField.startVisible = true
            proofTypeTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            proofTypeTextField.theme.bgColor = .white
            
            eventNameTextField.theme.cellHeight = 50
            eventNameTextField.startVisible = true
            eventNameTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            eventNameTextField.theme.bgColor = .white
            
            eventActivitiesTextField.theme.cellHeight = 50
            eventActivitiesTextField.startVisible = true
            eventActivitiesTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            eventActivitiesTextField.theme.bgColor = .white
        }
    }
    
    private func updateView(isInternalProof: Bool, event: StudentRegisteredEventDto = StudentRegisteredEventDto()) {
        if isInternalProof {
            organizationNameTextField.text = event.representativeOrganization.name
            addressTextField.text = event.address.fullAddress
            startTimeTextField.text = convertDateFormat(event.startAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
            endTimeTextField.text = convertDateFormat(event.endAt, dateNeedFormat: "HH:mm - dd/MM/yyyy")
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
    
}

extension CreateProofVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            proofImage.image = selectedImage
            viewModel.proofImage = selectedImage
            imagePicker?.dismiss(animated: true)
        }
    }
}

extension CreateProofVC: UITextFieldDelegate {
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

extension CreateProofVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
