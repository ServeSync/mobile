//
//  CreateProofVC.swift
//  PBL6
//
//  Created by KietKoy on 30/11/2023.
//

import UIKit
import SearchTextField

class CreateProofVC: BaseVC<CreateProofVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uploadProofView: UIView!
    @IBOutlet weak var eventTypeTextField: SearchTextField!
    @IBOutlet weak var eventNameTextField: SearchTextField!
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
    lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        eventTypeTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            view.endEditing(true)
            if itemPosition == 0 {
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
            }
            self.eventTypeTextField.text = item.title
        }
        
        eventNameTextField.itemSelectionHandler = { [weak self] filteredResults, itemPosition in
            guard let self = self else { return }
            let item = filteredResults[itemPosition]
            view.endEditing(true)
            self.updateView(isInternalProof: true, event: viewModel.getEvent(by: itemPosition))
            self.eventNameTextField.text = item.title
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
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.presentVC(imagePicker)
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
    }
}

extension CreateProofVC {
    private func configureEventTypeTextField() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            eventTypeTextField.filterStrings(viewModel.typeEvent)
            eventTypeTextField.theme.cellHeight = 50
            eventTypeTextField.startVisible = true
            eventTypeTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            eventTypeTextField.theme.bgColor = .white
            
            eventNameTextField.theme.cellHeight = 50
            eventNameTextField.startVisible = true
            eventNameTextField.theme.font = UIFont(name: "OpenSans-Regular", size: 16)!
            eventNameTextField.theme.bgColor = .white
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
            
            organizationNameTextField.isEnabled = false
            addressTextField.isEnabled = false
            startTimeTextField.isEnabled = false
            endTimeTextField.isEnabled = false
            roleTextField.isEnabled = false
            scoreTextField.isEnabled = false
        }
    }
    
    private func setPaddingTextField() {
        eventTypeTextField.setLeftPaddingPoints(16)
        eventTypeTextField.setRightPaddingPoints(44)
        
        eventNameTextField.setLeftPaddingPoints(16)
        eventNameTextField.setRightPaddingPoints(44)
        
        organizationNameTextField.setLeftPaddingPoints(16)
        organizationNameTextField.setRightPaddingPoints(44)
        
        addressTextField.setLeftPaddingPoints(16)
        addressTextField.setRightPaddingPoints(44)
        
        startTimeTextField.setLeftPaddingPoints(16)
        startTimeTextField.setRightPaddingPoints(44)
        
        endTimeTextField.setLeftPaddingPoints(16)
        endTimeTextField.setRightPaddingPoints(44)
        
        attendanceTimeTextField.setLeftPaddingPoints(16)
        attendanceTimeTextField.setRightPaddingPoints(44)
        
        roleTextField.setLeftPaddingPoints(16)
        roleTextField.setRightPaddingPoints(44)
        
        scoreTextField.setLeftPaddingPoints(16)
        scoreTextField.setRightPaddingPoints(44)
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12,
                                                              left: 16,
                                                              bottom: 12,
                                                              right: 16)
    }
    
    private func makeDatePickerForAttendanceTime() {
        let inputView = UIView(frame: CGRectMake(0,0, self.view.frame.width, 350))
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
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
    
    @objc func handleDatePickerForAttendanceTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        attendanceTimeTextField.text = formatter.string(from: sender.date)
//        viewModel.startTime = sender.date
    }
    
    @objc func handleDoneButtonAttendanceTime(sender: UIButton) {
        attendanceTimeTextField.resignFirstResponder()
    }
}

extension CreateProofVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            proofImage.image = selectedImage
            imagePicker.dismiss(animated: true)
        }
    }
}
