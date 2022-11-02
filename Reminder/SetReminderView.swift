//
//  SetReminderView.swift
//  Reminder
//
//  Created by Aisultan Askarov on 31.10.2022.
//

import UIKit
import CoreData
import CoreMIDI

class SetReminderView: UIViewController {

    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let titleLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 32.5, weight: .bold)
        label.text = "Set Reminder"
        
        return label
    }()
    
    let remindMeToLbl: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.text = "Remind me to:"
        
        return label
    }()
    
    lazy var remindMeToTextField: TextFieldWithPadding = {
       
        let textField = TextFieldWithPadding()
        
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textField.textColor = UIColor.black
        textField.textAlignment = .left
        textField.placeholder = "do homework"
        textField.keyboardType = .default
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 5
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return textField
    }()
    
    lazy var setReminderBtn: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
        button.setTitle("Set Reminder", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.5, weight: .regular)
        button.addTarget(self, action: #selector(setReminder), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelBtn: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.0, weight: .regular)), for: .normal)
        button.tintColor = UIColor.black
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
    
    let datePickerForReminder: UIDatePicker = {
       
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = UIColor.clear
        datePicker.tintColor = UIColor.systemBlue
        datePicker.setValue(UIColor.clear, forKey: "backgroundColor")
        datePicker.contentHorizontalAlignment = .center

        return datePicker
    }()
    
    @objc func textDidChange(textField: UITextField) {
        
        if !remindMeToTextField.text!.isEmpty {
            
            setReminderBtn.isEnabled = !remindMeToTextField.text!.isEmpty
            setReminderBtn.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
            setReminderBtn.isEnabled = true
            setReminderBtn.layer.masksToBounds = false
            setReminderBtn.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
            setReminderBtn.layer.shadowOpacity = 0.4
            setReminderBtn.layer.shadowRadius = 8
            setReminderBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
            
        } else if remindMeToTextField.text!.isEmpty {
            
            setReminderBtn.isEnabled = false
            setReminderBtn.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
            setReminderBtn.layer.masksToBounds = true
            
        }
        
    }
    
    var notificationsList : [LocalNotifications] = []
    var pendingNotifications: [UNNotificationRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)

        view.backgroundColor = UIColor.white
        
        setViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setViews() {
        
        view.addSubview(titleLabel)
        view.addSubview(remindMeToLbl)
        view.addSubview(remindMeToTextField)
        view.addSubview(cancelBtn)
        view.addSubview(datePickerForReminder)
        view.addSubview(setReminderBtn)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        remindMeToLbl.translatesAutoresizingMaskIntoConstraints = false
        remindMeToTextField.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        datePickerForReminder.translatesAutoresizingMaskIntoConstraints = false
        setReminderBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        titleLabel.sizeToFit()

        NSLayoutConstraint.activate([
            cancelBtn.widthAnchor.constraint(equalToConstant: 35),
            cancelBtn.heightAnchor.constraint(equalToConstant: 35),
            cancelBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            cancelBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
        cancelBtn.layer.cornerRadius = 35/2
        
        NSLayoutConstraint.activate([
            remindMeToTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            remindMeToTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            remindMeToTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35),
            remindMeToTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            remindMeToLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            remindMeToLbl.bottomAnchor.constraint(equalTo: remindMeToTextField.topAnchor, constant: -5),
            remindMeToLbl.heightAnchor.constraint(equalToConstant: 30)
        ])
        remindMeToLbl.sizeToFit()
        
        NSLayoutConstraint.activate([
            datePickerForReminder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            datePickerForReminder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            datePickerForReminder.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15),
            datePickerForReminder.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            setReminderBtn.widthAnchor.constraint(equalToConstant: 175),
            setReminderBtn.heightAnchor.constraint(equalToConstant: 45),
            setReminderBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            setReminderBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
        ])
        setReminderBtn.layer.cornerRadius = 22.5
        
    }
    
    //MARK: -Exit gesture function
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    //MARK: -Setting reminder
    
    @objc func setReminder() {
        
        let currentNotificationCenter = UNUserNotificationCenter.current()
        let contentOfNotification = UNMutableNotificationContent()
        contentOfNotification.title = "Reminder!"
        contentOfNotification.body = "Don't forget to \(remindMeToTextField.text!)"
        contentOfNotification.sound = .default
        contentOfNotification.categoryIdentifier = "ReminderIdentifier"
        contentOfNotification.userInfo = ["value" : "Data with local notification"]
        
        let fireNotificationDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: datePickerForReminder.date)
        
        let triggerForNotifications = UNCalendarNotificationTrigger(dateMatching: fireNotificationDate, repeats: false)
        let request = UNNotificationRequest(identifier: "ReminderIdentifier", content: contentOfNotification, trigger: triggerForNotifications)
        
        currentNotificationCenter.add(request) { (error) in
            
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "Error in next workout reminder notifications")")
            }
            
        }
        
        let newNotification = LocalNotifications(context: CoreDataStack.context)
        
        newNotification.dateOfUpcomingNotification = datePickerForReminder.date
        newNotification.targetContentIdentifier = contentOfNotification.targetContentIdentifier
                    
        CoreDataStack.saveContext()
                
        checkNotifications()
        view.layoutIfNeeded()
        
    }
    
    func checkNotifications() {
        
        notificationsList = CoreDataStack().loadUpcomingNotification()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
             
            print("Count: \(notifications.count)")
            
            for item in notifications {
            
                print(item.content)
                self.pendingNotifications = notifications
                
            }
            
            if notifications.count == 0 {
                CoreDataStack.deleteContext(entity: "LocalNotifications")
            }
            
        }
        
        if !pendingNotifications.contains(where: {$0.content.targetContentIdentifier == notificationsList.last?.targetContentIdentifier}) {
                        
            
            
        } else if pendingNotifications.contains(where: {$0.content.targetContentIdentifier == notificationsList.last?.targetContentIdentifier}) {
            
            
        }
        
    }

}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}