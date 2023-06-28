//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by Ranvir Singh Virk on 4/14/23.
//Jonathon Mangan jonmanga@iu.edu
//Ranvir Virk rsvirk@iu.edu
//Sanmeet Singh ss140@iu.edu
//Music Player app
//Submitted: 04/28/2023

import AVFoundation
import UserNotifications
// Tried using MediaPlayer API, but it does not work on simulators, so had to switch to AVFoundation
// The AVFoundation is from IOS Academy
// Timer: https://stackoverflow.com/questions/24007518/how-can-i-use-timer-formerly-nstimer-in-swift
// SpriteKit: Apple docs and bar updation logic with help of ChatGPT

import UIKit
import SpriteKit

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    let del = UIApplication.shared.delegate as! AppDelegate
    
    var appDeligate: AppDelegate?
    var myModelRef: SongModel?
    
    var timer: Timer?
    
    var songNumber: Int = 0
    var songs: [Song] = []
    
    var player: AVAudioPlayer?
    
    var scene: Visulizer?
    var audioData: [Float] = [0, 0, 0, 0, 0]

    var timeRemaining: Int = 0
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var albumCoverScene: SKView!
    
    @IBOutlet var playerView: UIView!
    
    @IBOutlet weak var albumCover: UIImageView!
    
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    func changeLikeFill(){
        self.likeButton.setImage(UIImage(systemName: (myModelRef!.songs[songNumber].liked ? "heart.fill" : "heart")), for: .normal)
    }
    
    func updateSongModelState(){
        do{
            let f = FileManager.default
            let songModelURL = try f.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let songModelData = try PropertyListEncoder().encode(myModelRef)
            let songModelFile = songModelURL.appendingPathExtension("ModelState.txt")
            
            try songModelData.write(to: songModelFile)
        }
        catch{
            print("error")
        }
    }
    
    @IBAction func didTapLike(_ sender: Any) {
        myModelRef!.songs[songNumber].liked.toggle()
        //let song = myModelRef!.songs[songNumber]
        self.changeLikeFill()
        
        self.updateSongModelState()
    }
    
    func showPlayPause(_ isPlaying: Bool){
        let button = isPlaying ? "play.fill" : "pause.fill"
        self.playPauseButton.setImage(UIImage(systemName: button), for: .normal)
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        let isPlaying = self.player!.isPlaying
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if isPlaying == true{
            self.player?.pause()
        }
        else{
            self.player?.play()
        }
        self.showPlayPause(isPlaying)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.player?.stop()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.songNumber = (self.songs.count + (self.songNumber - 1))%self.songs.count
        self.play()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        self.player?.stop()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.songNumber = (self.songNumber + 1)%self.songs.count
        self.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDeligate = UIApplication.shared.delegate as? AppDelegate
        self.myModelRef = self.appDeligate?.songModel
        if myModelRef?.songs.count == 0{
            self.myModelRef?.configerSongs()
        }
        songs = myModelRef!.songs
        self.changeLikeFill()
        scene = Visulizer(size: albumCoverScene.bounds.size)
        albumCoverScene.presentScene(scene)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func resetButtons(){
        self.changeLikeFill()
        self.showPlayPause(self.player?.isPlaying ?? false)
    }
    
    func play(){
        playerView.setNeedsDisplay()
        self.resetButtons()
        // Get the position of the song playing
        let song = songs[songNumber]
        
        let songsDirectoryPath = Bundle.main.resourcePath?.appending("/Music")
        let songPath = URL(fileURLWithPath: songsDirectoryPath!).appendingPathComponent(song.trackName!).path
        
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: songPath))
        }
        catch{
            print(error)
        }
        
        player?.delegate = self
        
        player?.play()
        
        if let duration = player?.duration{
            if let currentTime = player?.currentTime {
                self.notificationAtTenSecondsLeft(songs[(self.songNumber + 1)%self.songs.count], duration-currentTime-10)
            }
        }
        
        
        albumCover.image = UIImage(named: song.coverName)
        titleName.text = song.songName
        artistName.text = song.artistName
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateVisualizer()
        }
    }
    
    func updateVisualizer() {
        player?.updateMeters()
        audioData[0] = Float(player?.currentTime ?? 0)
        audioData[1] = Float(player?.currentTime ?? 0)
        audioData[2] = Float(player?.currentTime ?? 0)
        audioData[3] = Float(player?.currentTime ?? 0)
        audioData[4] = Float(player?.currentTime ?? 0)
        scene?.updateBars(audioLevels: audioData)
        
        if player?.isPlaying == true {
            scene?.isPaused = false
        } else {
            scene?.isPaused = true
        }

    }
    
    
    
    // Code for Notification starts here
    func notificationAtTenSecondsLeft(_ song: Song, _ songDuration: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Next Song:"
        content.subtitle = song.songName!+" by "+song.artistName!
        //content.sound = UNNotificationSound.default

        // show this notification 10 seconds before song ends
        print("trigger notification with 10 seconds left")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: songDuration, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Increment index but don't go out of bounds
        self.songNumber = (self.songNumber + 1)%self.songs.count
        self.play()
    }


    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.play()
    }
}

class Visulizer: SKScene {
    var bars: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        let frameWidth = self.frame.size.width
        let frameHeight = self.frame.size.height
        
        for i in 0..<5 {
            let bar = SKShapeNode(rectOf: CGSize(width: 20, height: 50))
            bar.position = CGPoint(x: (CGFloat(i) * (frameWidth / 5)) + (frameWidth / 10), y: frameHeight / 2)
            addChild(bar)
            bars.append(bar)
        }
    }
    
    func updateBars(audioLevels: [Float]) {
        for i in 0..<bars.count {
            let bar = bars[i]
            var scale = CGFloat(audioLevels[i])
            
            scale = min(max(scale, 0), 1)
            
            let scaleAction = SKAction.scaleY(to: scale, duration: 0.1)
            bar.run(scaleAction)
            
            let rotateAction = SKAction.rotate(byAngle: scale * 0.1, duration: 0.1)
            bar.run(rotateAction)
            
            var xPos = (CGFloat(i) * (self.frame.size.width / 5)) + (self.frame.size.width / 10)
            
            let barWidth = bar.frame.size.width
            xPos = min(max(xPos, barWidth/2), self.frame.size.width - barWidth/2)
            
            let xPosAction = SKAction.moveTo(x: xPos, duration: 0.1)
            bar.run(xPosAction)
        }
    }
}
