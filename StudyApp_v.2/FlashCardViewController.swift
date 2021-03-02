//
//  FlashCardViewController.swift
//  StudyApp_v.2
//
//  Created by Jack Xiao on 11/8/20.
//

import UIKit
//protocol to send data back to view controller
protocol SendingArrayDelegateProtocol {
    func sendingArray(myData: [FlashCard])
    func sendingCellNumber(cellNumber: Int)

}

class FlashCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var ImageFlash: UIImageView!
    var delegate: SendingArrayDelegateProtocol? = nil
    var arrayFlashCards = [FlashCard]()
    var hidetext = true
    var tableViewCellNumber: Int?
    @IBOutlet var ViewQuiz: UIView!
    @IBOutlet var AddingView: UIView!
    @IBOutlet var Ready: UIButton!
    @IBOutlet var BlurEffect: UIVisualEffectView!
    var clock:Bool = true
    var flash:Bool = true
    @IBOutlet var Enteranswer: UITextField!
    @IBOutlet var Enterquestion: UITextField!
    @IBOutlet var clockquiz: UISwitch!
    @IBOutlet var flashquiz: UISwitch!
    var deleteCard:Bool = false
    @IBOutlet var delete: UIButton!
    var editingCell:Bool = false
    var editingCellIndex: Int?
    var size:CGSize = CGSize(width: 197, height: 230)

    @IBAction func RemoveImage(_ sender: Any) {
        ImageFlash.image = nil
    }
    @IBAction func Addimage(_ sender: Any) {
//set the image picker allows the user to add images
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionsheet = UIAlertController(title: "Photos Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
//takes the image selected and stores it in ImageFlash
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        ImageFlash.image = image
        picker.dismiss(animated: true, completion: nil)
    }
//the user pressed cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//deletes the flash if user click on the button then the flash card
    @IBAction func Delete(_ sender: Any) {
        deleteCard.toggle()
        if(deleteCard == true){
            delete.setTitle("Done", for: .normal)
        }else{
            delete.setTitle("Delete Flashcard", for: .normal)
        }
        if(arrayFlashCards.isEmpty == true){
            print("true")
        }
        sendingToViewController()
    }
//sets the  clock ticking sound in the quiz part.
    @IBAction func QuizAlarm(_ sender: Any) {
        clock = clockquiz.isOn
    }
//sets the flashing background
    @IBAction func QuizFlash(_ sender: Any) {
        flash = flashquiz.isOn
    }
//goes to the quiz.
    @IBAction func ReadyToQuiz(_ sender: Any) {
        BlurEffect.isHidden = true
        animationOut(views: ViewQuiz)
        if(arrayFlashCards.isEmpty == false){
            performSegue(withIdentifier: "seguetoQuiz", sender: self)
        }
    }
//sends data to the quiz
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetoQuiz"{
            let testView: TestViewController = segue.destination as! TestViewController
            testView.FlashCards = arrayFlashCards
            testView.clock = clock
            testView.flash = flash
        }
    }
//values for the flashcards
    @IBAction func Normal(_ sender: Any) {
        size = CGSize(width: 197, height: 230)
    }
    
    @IBAction func Large(_ sender: Any) {
        size = CGSize(width: 400, height: 230)
    }
    @IBOutlet var collectionView: UICollectionView!
//button to add flashcards
    @IBAction func AddFlashCard(_ sender: Any) {
        BlurEffect.isHidden = false
        animationIn(views: AddingView)
       
    }
//takes the user inputed data and set flashcards when pressed done.
    @IBAction func DoneAdding(_ sender: Any) {
        if(editingCell == false && Enterquestion.text?.isEmpty == false && Enteranswer.text?.isEmpty == false){
            let addingCellInfo = FlashCard(questions: "", answers: "", size: size, image: nil)
            addingCellInfo.answers = Enteranswer.text!
            addingCellInfo.questions = Enterquestion.text!
            addingCellInfo.image = ImageFlash.image
            self.arrayFlashCards.append(addingCellInfo)
            let indexPath = IndexPath(row: self.arrayFlashCards.count-1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
           
        }
        else if(editingCell == true && Enterquestion.text?.isEmpty == false && Enteranswer.text?.isEmpty == false){
            arrayFlashCards[editingCellIndex!].answers = Enteranswer.text!
            arrayFlashCards[editingCellIndex!].questions = Enterquestion.text!
            arrayFlashCards[editingCellIndex!].image = ImageFlash.image
            arrayFlashCards[editingCellIndex!].size = size
            let indexPath = IndexPath(row: self.arrayFlashCards.count-1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
            editingCell.toggle()
        }
        
        sendingToViewController()
        
        BlurEffect.isHidden = true
        animationOut(views: AddingView)
     
    }
//fucntion to sends data back to view controller
    func sendingToViewController(){
        if self.delegate != nil{self.delegate?.sendingArray(myData: self.arrayFlashCards)}
        if self.delegate != nil{self.delegate?.sendingCellNumber(cellNumber:self.tableViewCellNumber!)}
    }

//run the animation and goes to quiz view controller
    @IBAction func Quiz(_ sender: Any) {
        BlurEffect.isHidden = false
        animationIn(views: ViewQuiz)
    }
    

    
    func animationIn(views: UIView){
        self.view.addSubview(views)
        views.center = self.view.center
        
        views.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        views.alpha = 0
        
        UIView.animate(withDuration: 0.2){
            self.BlurEffect.effect = self.effect
            views.alpha = 1
            views.transform = CGAffineTransform.identity
        }
    }
    func animationOut(views: UIView){
        UIView.animate(withDuration: 0.1, animations: {
            views.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            views.alpha = 0
            
            self.BlurEffect.effect = nil
        }) { (success:Bool) in
            views.removeFromSuperview()
        }
    }
    
    var effect:UIVisualEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomizeCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomizeCollectionViewCell.identifier)
        title = "Flashcards"
        effect = BlurEffect.effect
        BlurEffect.effect = nil
        
        AddingView.layer.cornerRadius = 10
        AddingView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        AddingView.layer.shadowOffset = CGSize(width: 0, height: 3)
        AddingView.layer.shadowOpacity = 1.0
        AddingView.layer.shadowRadius = 3.0
        
        ViewQuiz.layer.cornerRadius = 10
        ViewQuiz.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ViewQuiz.layer.shadowOffset = CGSize(width: 0, height: 3)
        ViewQuiz.layer.shadowOpacity = 1.0
        ViewQuiz.layer.shadowRadius = 3.0
        
    }
}


extension FlashCardViewController: UICollectionViewDataSource{
// number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFlashCards.count
    }
//contents of the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomizeCollectionViewCell.identifier,for: indexPath)as! CustomizeCollectionViewCell
        
        cell.Answertext.text = arrayFlashCards[indexPath.row].answers
        cell.Questiontext.text = arrayFlashCards[indexPath.row].questions
        cell.Image.image = arrayFlashCards[indexPath.row].image
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 3.0
        cell.layer.masksToBounds = false
        
        if(arrayFlashCards[indexPath.row].image != nil){
            
            cell.Answertext.frame.origin = CGPoint(x: 12, y: 163)
            cell.Questiontext.frame.origin = CGPoint(x: 12, y: 163)
            cell.Answertext.frame.size = CGSize(width: 174, height: 67)
            cell.Questiontext.frame.size = CGSize(width: 174, height: 67)
            cell.Answertext.textAlignment = .left
            cell.Questiontext.textAlignment = .left
           // print(" yes image ------------------------------------------")
        }
        if(arrayFlashCards[indexPath.row].image == nil){
            cell.Answertext.frame.origin = CGPoint(x: 0, y: 10)
            cell.Questiontext.frame.origin = CGPoint(x: 0, y: 10)
            cell.Answertext.frame.size = CGSize(width: 174, height: 190)
            cell.Questiontext.frame.size = CGSize(width: 174, height: 190)
            cell.Answertext.textAlignment = .center
            cell.Questiontext.textAlignment = .center
           // print("no image ------------------------------------------")
        }
        cell.Edit.tag = indexPath.item
        cell.Edit.addTarget(self, action: #selector(editClicked), for: .touchUpInside)
        
        return cell
    }
//when clicked on the edit cell
    @objc func editClicked(_sender: UIButton){
        editingCellIndex = _sender.tag
        editingCell = true
        BlurEffect.isHidden = false
        animationIn(views: AddingView)
    }

}

extension FlashCardViewController: UICollectionViewDelegate{
//clicked on the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped \(indexPath)")
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomizeCollectionViewCell else {return}
        if(deleteCard == false){
                hidetext.toggle()
                cell.Answertext?.isHidden = hidetext
                cell.Questiontext?.isHidden = !hidetext
        }else {
            arrayFlashCards.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }

    }
}
extension FlashCardViewController: UICollectionViewDelegateFlowLayout{
//sets the sizes using the varible of size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return arrayFlashCards[indexPath.row].size
    }
}

class FlashCard{
    var questions: String
    var answers: String
    var size:CGSize
    var image: UIImage?
    
    init(questions: String, answers: String, size: CGSize, image: UIImage?){
        self.questions = questions
        self.answers = answers
        self.size = size
        self.image = image
    }
    
}
