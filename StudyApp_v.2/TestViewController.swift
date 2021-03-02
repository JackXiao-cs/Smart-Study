//
//  TestViewController.swift
//  StudyApp_v.2
//
//  Created by Jack Xiao
//  Copyright © 2020 jack xiao. All rights reserved.
// added cocoapods library SAConfetti

import UIKit
import AVFoundation
import SAConfettiView

class TestViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    var FlashCards = [FlashCard]()
    var SaveFlash = [FlashCard]()
    @IBOutlet var QuestionLabel: UILabel!
    var number: Int? = nil
    var timer = Timer()
    var timer2 = Timer()
    var correct: Int = 0
    @IBOutlet var ImageQuestion: UIImageView!
    
    var clock:Bool?
    var flash:Bool?
    
    let confettiView = SAConfettiView()
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
   

//button 1
    @IBAction func Button1(_ sender: UIButton){
        let buttonTitle = sender.titleLabel?.text
        if(buttonTitle != nil && correct != SaveFlash.count){
            makeButton(button: button1, buttonTitle: buttonTitle!)
        }
        if(buttonTitle == nil){
            makeButton(button: button1, buttonTitle: " ")
        }
    }
//button 2
    @IBAction func Button2(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        if(buttonTitle != nil && correct != SaveFlash.count){
            makeButton(button: button2, buttonTitle: buttonTitle!)
        }
        if(buttonTitle == nil){
            makeButton(button: button2, buttonTitle: " ")
        }
   
    }
//button 3
    @IBAction func Button3(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        if(buttonTitle != nil && correct != SaveFlash.count){
            makeButton(button: button3, buttonTitle: buttonTitle!)
        }
        if(buttonTitle == nil){
            makeButton(button: button3, buttonTitle: " ")
        }
    }
//button 4
    @IBAction func Button4(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        if(buttonTitle != nil && correct != SaveFlash.count){
            makeButton(button: button4, buttonTitle: buttonTitle!)
        }
        if(buttonTitle == nil){
            makeButton(button: button4, buttonTitle: " ")
        }
    }
    
    @IBOutlet var progressBar: UIProgressView!
    
    var delegate: SendingArrayDelegateProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveFlash = FlashCards
        title = "Quiz"
        begin()
        if(clock == true){
            audio(loop: -1)
        }
        progressBar.progress = 0.0
        
        print("Saveflash \(SaveFlash.count)  Correct \(correct)")
        
        if(correct != SaveFlash.count && flash == true){
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction2), userInfo: nil, repeats: true)
            
        }
    }
//stop timer and confetti when leaving view.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        timer.invalidate()
        timer2.invalidate()
        confettiView.stopConfetti()
    }
//memory leaking
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//plays audio for a certian amount of time 0 is loop 1 is 1 sec
    func audio(loop: Int){
        let pathToSound = Bundle.main.path(forResource: "Clock", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }catch{
            
        }
    }
//sets the first question
    func begin(){
        if(FlashCards.isEmpty == false){
            self.number = randNumber()
            QuestionLabel.text = FlashCards[number!].answers
            if(FlashCards[number!].image != nil){
                ImageQuestion.image = FlashCards[number!].image
            }else{
                ImageQuestion.image = nil
            }
            setButton(number: number!)
        }
       
    }
//switch between the background color to simulate flashing
    @objc func timerAction(){
        self.view.backgroundColor = UIColor.red
    }
    @objc func timerAction2(){
        self.view.backgroundColor = UIColor.white
    }
//set and makes the buttins and adds animation
    func makeButton(button: UIButton, buttonTitle: String?){

        if(FlashCards.indices.contains(number!)){
            if(buttonTitle! == FlashCards[number!].questions || (FlashCards[number!].questions.isEmpty && buttonTitle == " ")){
                correct += 1
                progressBar.progress += 1/Float(SaveFlash.count)
                print("\(correct) ------\(1/Float(SaveFlash.count))")
                button.backgroundColor = UIColor.green
                button.setTitleColor(UIColor.black, for: .normal)
                FlashCards.remove(at: number!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    button.backgroundColor = UIColor.systemBlue
                    button.setTitleColor(UIColor.white, for: .normal)
                    if(self.correct != self.SaveFlash.count){self.begin()}
                }
            }else{
                button.backgroundColor = UIColor.systemRed
                button.setTitleColor(UIColor.black, for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    button.backgroundColor = UIColor.systemBlue
                    button.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
//check if the user completed the quiz
        if(correct == SaveFlash.count){
            timer.invalidate()
            timer2.invalidate()
            self.view.backgroundColor = UIColor.white
            audioPlayer?.stop()
            confettiView.type = .Star
            self.view.addSubview(confettiView)
            confettiView.startConfetti()
        }
    }
//randomize the questions and order using other flashcards
    func randNumber()-> Int{
        let number = Int.random(in: 0..<FlashCards.count)
        return number
    }
//sets the randomized buttons
    func setButton(number: Int){
        var ButtonArray = [button1, button2, button3, button4]
        var values = Array(0..<SaveFlash.count)
        values.remove(at: number)
        for _ in ButtonArray{
            if(values.isEmpty != true){
                let selectedButton = ButtonArray.randomElement()!
                let selectedFlash = values.randomElement()!
                selectedButton!.setTitle(SaveFlash[selectedFlash].questions, for: .normal)
                ButtonArray.remove(at: ButtonArray.firstIndex(of: selectedButton!)!)
                if(values.count != 1){
                    values.remove(at: values.firstIndex(of: selectedFlash)!)
                }
            }
        }
        let ButtonArrayAnswer = [button1, button2, button3, button4]
        if(FlashCards[number].questions.isEmpty){
            ButtonArrayAnswer.randomElement()!?.setTitle(" ", for: .normal)
        }else{
            ButtonArrayAnswer.randomElement()!?.setTitle(FlashCards[number].questions, for: .normal)
        }
        
    }
}
