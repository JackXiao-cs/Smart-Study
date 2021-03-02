//
//  ViewController.swift
//  StudyApp_v.2
//
//  Created by Jack Xiao on 11/8/20.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, SendingArrayDelegateProtocol
{

    var receivedArray = [FlashCard]()
    var cellNumber:Int?
    var recievedCellNumber:Int?
    var CellTopicArray = [CellInfo]()
    let cellSpacingHeight: CGFloat = 6
    var Pickedcolor: UIColor = UIColor.white
    var textcolor: UIColor = UIColor.black
    var recievedRemoval: Bool = false
    @IBOutlet var addItemView: UIView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var EnterSubject: UITextField!
    @IBOutlet var EnterDescription: UITextField!
    @IBOutlet var red: UIButton!
    @IBOutlet var orange: UIButton!
    @IBOutlet var yellow: UIButton!
    @IBOutlet var green: UIButton!
    @IBOutlet var purple: UIButton!
    @IBOutlet var cyan: UIButton!
    @IBOutlet var lightblue: UIButton!
    @IBOutlet var lightgreen: UIButton!
    @IBOutlet var pink: UIButton!
    @IBOutlet var greyblue: UIButton!
    @IBOutlet var indigo: UIButton!
    @IBOutlet var blue: UIButton!
    @IBOutlet var labelTopicColor: UILabel!
    @IBOutlet var labelAddingTopic: UILabel!
    @IBOutlet var DoneButton: UIButton!
    @IBOutlet var blackText: UIButton!
    @IBOutlet var whiteText: UIButton!
    @IBOutlet var labelTextColor: UILabel!
    @IBOutlet weak var date: UIDatePicker!
    
    @IBOutlet weak var reminder: UISwitch!
    @IBAction func SetReminder(_ sender: Any) {
//Code for reminder. This sets the reminder on.
        switch reminder.isOn{
        case true:
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]){
                (granted, error) in
            }
            let content = UNMutableNotificationContent()
            content.title = "Time to Study"
            content.body = "This is a reminder to study"

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date.date)
            let trigger =
            UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            center.add(request){(error) in}
            break
        case false:
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            break
            
        }
    }
//removes all the data for the date, so no notification is sent when the button is turned off
    @IBAction func Datestate(_ sender: Any) {
        reminder.setOn(false, animated: true)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
//when clicking edit on the cell the view will popup
    var rowIndex:Int?
    var editingCell = false
    @IBAction func EditCell(_ sender: Any) {
        let buttonPostion = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: tableView)

              if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
                self.rowIndex =  indexPath.row
                editingCell = true
              }
        visualEffectView.isHidden = false
        animationIn()
        EnterSubject.text = ""
        EnterDescription.text = ""
    }
    
//these set the tableview cells the color of the cell and text
    @IBAction func BlackText(_ sender: Any) {
        self.textcolor = UIColor.black
        self.labelAddingTopic.textColor = UIColor.black
        self.labelTopicColor.textColor = UIColor.black
        self.labelTextColor.textColor = UIColor.black
        buttonAnimation (button: blackText)
    }
    @IBAction func WhiteText(_ sender: Any) {
        self.textcolor = UIColor.white
        self.labelAddingTopic.textColor = UIColor.white
        self.labelTopicColor.textColor = UIColor.white
        self.labelTextColor.textColor = UIColor.white
        buttonAnimation (button: whiteText)
    }
    @IBAction func Red(_ sender: Any) {
        Pickedcolor = UIColor.red
        self.addItemView.backgroundColor = UIColor.red
        buttonAnimation (button: red)
    }
    @IBAction func Orange(_ sender: Any) {
        Pickedcolor = UIColor.orange
        self.addItemView.backgroundColor = UIColor.orange
        buttonAnimation (button: orange)
    }
    @IBAction func Yellow(_ sender: Any) {
        Pickedcolor = UIColor.white
        self.addItemView.backgroundColor = UIColor.white
        buttonAnimation (button: yellow)
    }
    @IBAction func Green(_ sender: Any) {
        Pickedcolor = UIColor.green
        self.addItemView.backgroundColor = UIColor.green
        buttonAnimation (button: green)
    }
    @IBAction func Blue(_ sender: Any) {
        Pickedcolor = UIColor.blue
        self.addItemView.backgroundColor = UIColor.blue
        buttonAnimation (button: blue)
    }
    @IBAction func Indigo(_ sender: Any) {
        Pickedcolor = UIColor.systemIndigo
        self.addItemView.backgroundColor = UIColor.systemIndigo
        buttonAnimation (button: indigo)
    }
    @IBAction func Purple(_ sender: Any) {
        Pickedcolor = UIColor.purple
        self.addItemView.backgroundColor = UIColor.purple
        buttonAnimation (button: purple)
    }
    @IBAction func GreyBlue(_ sender: Any) {
        self.Pickedcolor = UIColor.init(displayP3Red: 147/255, green: 165/255, blue: 252/255, alpha: 1)
        self.addItemView.backgroundColor = UIColor.init(displayP3Red: 147/255, green: 165/255, blue: 252/255, alpha: 1)
        buttonAnimation (button: greyblue)
    }
    @IBAction func Pink(_ sender: Any) {
        self.Pickedcolor = UIColor.init(displayP3Red: 252/255, green: 180/255, blue: 226/255, alpha: 1)
        self.addItemView.backgroundColor = UIColor.init(displayP3Red: 252/255, green: 180/255, blue: 226/255, alpha: 1)
        buttonAnimation (button: pink)
    }
    @IBAction func LightGreen(_ sender: Any) {
        self.Pickedcolor = UIColor.init(displayP3Red: 200/255, green: 252/255, blue: 108/255, alpha: 1)
        self.addItemView.backgroundColor = UIColor.init(displayP3Red: 200/255, green: 252/255, blue: 108/255, alpha: 1)
        buttonAnimation (button: lightgreen)
    }
    @IBAction func LightBlue(_ sender: Any) {
        self.Pickedcolor = UIColor.init(displayP3Red: 101/255, green: 207/255, blue: 251/255, alpha: 1)
        self.addItemView.backgroundColor = UIColor.init(displayP3Red: 101/255, green: 207/255, blue: 251/255, alpha: 1)
        buttonAnimation (button: lightblue)
    }
    @IBAction func Cyan(_ sender: Any) {
        self.Pickedcolor = UIColor.init(displayP3Red: 156/255, green: 252/255, blue: 221/255, alpha: 1)
        self.addItemView.backgroundColor = UIColor.init(displayP3Red: 156/255, green: 252/255, blue: 221/255, alpha: 1)
        buttonAnimation (button: cyan)
    }
// sets the shadow and the overall look of the button
    func buttonAnimation (button: UIButton){
        button.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        button.alpha = 0
        UIView.animate(withDuration: 0.4){
            button.alpha = 1
            button.transform = CGAffineTransform.identity
        }
    }
//gets the array of flash cards from flashcards.
    func sendingArray(myData: [FlashCard]) {
        self.receivedArray = myData
    }
//gets what cell the flash card belongs too.
    func sendingCellNumber(cellNumber: Int) {
        self.recievedCellNumber = cellNumber
    }
//sets values in flashcards. It sets tableview cell and the array that would be built in flashcards
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFlashcard"{
            let flashView: FlashCardViewController = segue.destination as! FlashCardViewController
            flashView.delegate = self
            flashView.tableViewCellNumber = cellNumber
            flashView.arrayFlashCards = CellTopicArray[cellNumber!].arrayData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

        
    @IBOutlet weak var tableView: UITableView!
//popup for adding topics
    @IBAction func AddTopic(_ sender: Any) {
        visualEffectView.isHidden = false
        animationIn()
        EnterSubject.text = ""
        EnterDescription.text = ""
    }
    
    var effect:UIVisualEffect!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 172
        title = "Topics"
        
        EnterSubject.layer.borderColor = UIColor.white.cgColor
        EnterDescription.layer.borderColor = UIColor.white.cgColor
        EnterDescription.layer.borderWidth = 2
        EnterSubject.layer.borderWidth = 2
        
        DoneButton.layer.cornerRadius = 10
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addItemView.layer.cornerRadius = 20
        buttonSetter(button: red)
        buttonSetter(button: orange)
        buttonSetter(button: yellow)
        buttonSetter(button: green)
        buttonSetter(button: blue)
        buttonSetter(button: indigo)
        buttonSetter(button: purple)
        buttonSetter(button: greyblue)
        buttonSetter(button: pink)
        buttonSetter(button: lightgreen)
        buttonSetter(button: lightblue)
        buttonSetter(button: cyan)
        buttonSetter(button: blackText)
        buttonSetter(button: whiteText)
        
        addItemView.layer.cornerRadius = 10
        addItemView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addItemView.layer.shadowOffset = CGSize(width: 0, height: 3)
        addItemView.layer.shadowOpacity = 1.0
        addItemView.layer.shadowRadius = 3.0
        
        
//notification code to grant access to send notifitcation
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]){
            (granted, error) in
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Study"
        content.body = "This is a reminder to study"
        
      let date = Date().addingTimeInterval(10)

      let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger =
        UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request){(error) in}
    }
// function that sets the look of the buttons
    func buttonSetter(button: UIButton){
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 3.0
        button.layer.masksToBounds = false
    }
// animation for the view pop in
    func animationIn(){
        
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.2){
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
// animation for the view pop out
    func animationOut(){
        UIView.animate(withDuration: 0.1, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            self.addItemView.removeFromSuperview()
        }
    }
//when done sets the cells and add the data to CelltopicArray
    @IBAction func done(_ sender: Any) {
        let Subject = EnterSubject
        let Description = EnterDescription
        
        if(Subject?.text != "" && Description?.text != "" && editingCell == false){
            let addingCellInfo = CellInfo(TopicName: "", DiscriptionOfTopic: "",color: UIColor.orange, textColor: UIColor.black)
            addingCellInfo.TopicName = (Subject?.text)!
            addingCellInfo.DiscriptionOfTopic = (Description?.text)!
            addingCellInfo.color = Pickedcolor
            addingCellInfo.textColor = textcolor
            self.CellTopicArray.append(addingCellInfo)
            self.tableView.reloadData()
        }
        if(Subject?.text != "" && Description?.text != "" && editingCell == true){
            CellTopicArray[rowIndex!].TopicName = (Subject?.text)!
            CellTopicArray[rowIndex!].DiscriptionOfTopic = (Description?.text)!
            CellTopicArray[rowIndex!].color = Pickedcolor
            CellTopicArray[rowIndex!].textColor = textcolor
            self.tableView.reloadData()
        }
        visualEffectView.isHidden = true
        animationOut()
        editingCell = false
    }
}
//when the cell is clicked code
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        cellNumber = indexPath.row
        if (recievedCellNumber != nil){
            CellTopicArray[recievedCellNumber!].recievedCellNumber = recievedCellNumber
            CellTopicArray[recievedCellNumber!].arrayData = receivedArray
            dump( CellTopicArray[recievedCellNumber!].arrayData)
        }

        self.performSegue(withIdentifier: "segueToFlashcard", sender: self)
    }
    
}

extension ViewController: UITableViewDataSource{
//adds rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellTopicArray.count
    }
    
//contents of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomizeTableViewCell
        let topic = CellTopicArray[indexPath.row]
        let gradientLayer = CAGradientLayer()

        var red:CGFloat = 0
        var blue:CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        let darker:CGFloat = 0.7
        _ = topic.color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let color = CGColor(red: red * darker, green: green * darker, blue: blue * darker, alpha: alpha)
        
        gradientLayer.colors = [topic.color!.cgColor, color]
        gradientLayer.frame = cell.CellColor.bounds
        cell.CellColor?.layer.addSublayer(gradientLayer)
        
        cell.CellTitle?.text = topic.TopicName
        cell.CellDetails?.text = topic.DiscriptionOfTopic
        cell.CellDetails?.textColor = topic.textColor
        cell.CellTitle?.textColor = topic.textColor
        cell.CellColor?.layer.cornerRadius = 10

        return cell
    }
    
//when deleting the cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            CellTopicArray.remove(at: indexPath.row)
            recievedCellNumber = nil
            receivedArray.removeAll()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}



class CellInfo{
    var TopicName: String
    var DiscriptionOfTopic: String
    var arrayData = [FlashCard]()
    var recievedCellNumber: Int?
    var color: UIColor?
    var textColor: UIColor?
    
    init(TopicName: String, DiscriptionOfTopic: String, color: UIColor, textColor:UIColor){
        self.TopicName = TopicName
        self.DiscriptionOfTopic = DiscriptionOfTopic
        self.color = color
        self.textColor = textColor
    }
    
}
