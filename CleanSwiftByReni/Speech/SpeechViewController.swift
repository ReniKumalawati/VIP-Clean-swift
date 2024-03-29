//
//  SpeechViewController.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 10/05/19.
//  Copyright (c) 2019 Bootcamp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Speech

protocol SpeechDisplayLogic: class
{
  func displaySomething(viewModel: Speech.Something.ViewModel)
}

class SpeechViewController: UIViewController, SFSpeechRecognizerDelegate, SpeechDisplayLogic
{
    var interactor: SpeechBusinessLogic?
    var router: (NSObjectProtocol & SpeechRoutingLogic & SpeechDataPassing)?
    let audoEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording:Bool = false
    
    @IBOutlet weak var startButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = SpeechInteractor()
        let presenter = SpeechPresenter()
        let router = SpeechRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.requestSpeechAuthorization()
        doSomething()
    }
    
    func doSomething()
    {
        let request = Speech.Something.Request()
        interactor?.doSomething(request: request)
    }
  
    func displaySomething(viewModel: Speech.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    @IBAction func startOrStop(_ sender: UIButton ) {
        if isRecording == true {
            audoEngine.stop()
            request?.endAudio()
            isRecording = false
            print(isRecording)
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            print(isRecording)
        }
    }

    func recordAndRecognizeSpeech () {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audio session properties were not set because an error")
        }
        request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audoEngine.inputNode
        
        request?.shouldReportPartialResults = true
        recognitionTask = speechRecognizer!.recognitionTask(with: request!, resultHandler: {(result, error) in
            var isFinal = false
            if result != nil {
                print(result?.bestTranscription.formattedString)
                isFinal = result!.isFinal
            }
            if error != nil || isFinal {
                self.audoEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionTask = nil
                self.isRecording = false
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){(buffer, when) in
            self.request?.append(buffer)
        }
        audoEngine.prepare()
        do {
            try audoEngine.start()
        } catch {
            print("audio engine coudnt start because of an error")
        }
    }
    
    func cancelRecording() {
        audoEngine.stop()
        
        let node = audoEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startButton.isEnabled = true
                case .denied:
                    self.startButton.isEnabled = false
                    print("User denied access to speech recognition")
                case .restricted:
                    self.startButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    self.startButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                }
            }
        }
    }
    
}
