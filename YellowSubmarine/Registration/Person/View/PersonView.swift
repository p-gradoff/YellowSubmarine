import UIKit

protocol PersonViewProtocol : UIScrollView {
    var sendData: ((UIImage) -> Void)? { get set }
    var chooseProfilePicture: (() -> Void)? { get set }
    
    var imagePicker: UIImagePickerController { get set }
    
    func getPersonData() -> PersonData
}

final class PersonView: UIScrollView {
    
    var sendData: ((UIImage) -> Void)?
    var chooseProfilePicture: (() -> Void)?
    
    private lazy var contentView : UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    // TODO: make doubled imageView
    
    private lazy var upContentImageView : UIImageView = {
        .config(view: UIImageView()) {
            $0.image = .background
            $0.isUserInteractionEnabled = true
        }
    }()
    
    private lazy var downContentImageView : UIImageView = {
        .config(view: UIImageView()) {
            $0.image = .backgroundDown
            $0.isUserInteractionEnabled = true
        }
    }()
    
    private lazy var personLabel = AppUI.createLabel(
        withText: "Personal\nInformation",
        textColor: .appBrown,
        font: .getAmitaFont(fontType: .bold, fontSize: 50),
        alignment: .left
    )
    
    private lazy var tapGest = UITapGestureRecognizer(target: self, action: #selector(onProfileImageViewTap))

    private lazy var profileImageView : UIImageView = AppUI.createImageView(
        image: .camera,
        tintColor: .appBrown,
        cornerRadius: 50,
        borderWidth: 4
    )
    
    internal lazy var imagePicker : UIImagePickerController = {
        $0.delegate = self
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        return $0
    }(UIImagePickerController())
    
    private lazy var nameLabel = AppUI.createLabel(
        withText: "Enter your name:",
        textColor: .appOrange,
        font: .getMeriendaFont(fontSize: 24),
        alignment: .left
    )
    
    private lazy var nameTextField = AppUI.createTextField(
        withPlaceholder: "",
        placeholderColor: .appPlaceholder,
        bgColor: .appLightYellow,
        font: .getMontserratFont(fontSize: 16),
        textColor: .appBrown,
        leftViewPic: "highlighter",
        cornerRadius: 20)
    
    private lazy var genderLabel : UILabel = AppUI.createLabel(
        withText: "Choose your gender:",
        textColor: .appOrange,
        font: .getMeriendaFont(fontSize: 24),
        alignment: .left
    )
    
    private lazy var genderSegmentControl : UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.insertSegment(withTitle: "Male", at: 0, animated: true)
        $0.insertSegment(withTitle: "Female", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
        $0.backgroundColor = .appLightYellow
        $0.selectedSegmentTintColor = .appLightBrown
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.appBrown], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        return $0
    }(UISegmentedControl())
    
    private lazy var birthdayLabel : UILabel = AppUI.createLabel(
        withText: "Set your Birthday:",
        textColor: .appOrange,
        font: .getMeriendaFont(fontSize: 24),
        alignment: .left)
    
    private lazy var datePicker : UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.minimumDate = createDate(day: 1, month: 1, year: 1924)
        $0.maximumDate = Date.now
        $0.date = Date.now
        $0.backgroundColor = .appLightYellow
        $0.tintColor = .red
        return $0
    }(UIDatePicker())
    
    private lazy var dateView : UIView = {
        .config(view: UIView()) { [weak self] in
            guard let self = self else { return }
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .appLightYellow
            $0.addSubview(datePicker)
            
            NSLayoutConstraint.activate([
                datePicker.centerXAnchor.constraint(equalTo: $0.centerXAnchor),
                datePicker.centerYAnchor.constraint(equalTo: $0.centerYAnchor),
            ])
        }
    }()
    
    private lazy var sendButton : UIButton = {
        .config(view: UIButton()) { [weak self] in
            guard let self = self else { return }
            $0.setImage(.regMarine, for: .normal)
            $0.addTarget(self, action: #selector(onSendDataTouched), for: .touchDown)
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PersonView {
    
    private func createDate(day: Int, month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = calendar.date(from: dateComponents)
        return date ?? Date.now
    }
    
    private func setUpView() {
        profileImageView.addGestureRecognizer(tapGest)
        
        upContentImageView.addSubviews(personLabel, profileImageView, nameLabel, nameTextField, genderLabel, genderSegmentControl, birthdayLabel, dateView)
        downContentImageView.addSubviews(sendButton)
        contentView.addSubviews(upContentImageView, downContentImageView)
        addSubview(contentView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            upContentImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upContentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upContentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            upContentImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            
            personLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            personLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            personLabel.widthAnchor.constraint(equalToConstant: 300),
            
            profileImageView.topAnchor.constraint(equalTo: personLabel.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: personLabel.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: personLabel.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: personLabel.leadingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 280),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            genderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            genderLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            
            genderSegmentControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            genderSegmentControl.leadingAnchor.constraint(equalTo: genderLabel.leadingAnchor, constant: 20),
            genderSegmentControl.widthAnchor.constraint(equalToConstant: 250),
            genderSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            
            birthdayLabel.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: 40),
            birthdayLabel.leadingAnchor.constraint(equalTo: genderSegmentControl.leadingAnchor, constant: 30),
            
            dateView.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 20),
            dateView.centerXAnchor.constraint(equalTo: birthdayLabel.centerXAnchor),
            dateView.widthAnchor.constraint(equalToConstant: 140),
            dateView.heightAnchor.constraint(equalToConstant: 50),
            
            downContentImageView.topAnchor.constraint(equalTo: upContentImageView.bottomAnchor),
            downContentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            downContentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            downContentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // sendButton.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            sendButton.topAnchor.constraint(equalTo: downContentImageView.topAnchor, constant: 200),
            sendButton.centerXAnchor.constraint(equalTo: dateView.trailingAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 85),
            sendButton.heightAnchor.constraint(equalToConstant: 80),
            sendButton.bottomAnchor.constraint(equalTo: downContentImageView.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func onProfileImageViewTap() {
        self.chooseProfilePicture?()
    }
    
    @objc private func onSendDataTouched() {
        guard let image = profileImageView.image else { print("no image"); return}
        self.sendData?(image)
    }
}

extension PersonView : PersonViewProtocol {
    
    func getPersonData() -> PersonData {
        PersonData(
            name: nameTextField.text ?? .simpleNickname,
            gender: genderSegmentControl.titleForSegment(at: genderSegmentControl.selectedSegmentIndex) ?? .simpleGender,
            birthday: datePicker.date)
    }
}

extension PersonView : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            profileImageView.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true)
    }
}
