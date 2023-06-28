//
//  AppDelegate.swift
//  MusicApp
//
//  Created by Jonathon Mangan on 4/10/23.
//Jonathon Mangan jonmanga@iu.edu
//Ranvir Virk rsvirk@iu.edu
//Sanmeet Singh ss140@iu.edu
//Music Player app
//Submitted: 04/28/2023

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var songModel : SongModel = SongModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        do{
            let f = FileManager.default
            let songModelURL = try f.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let songModelFile = songModelURL.appendingPathExtension("ModelState.txt")
            let songModelData = try Data(contentsOf: songModelFile)
            
            let data = try PropertyListDecoder().decode(SongModel.self, from: songModelData)
            
            songModel.songs = data.songs
        }
        catch{
            print("error")
        }
    
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
      ) {
        completionHandler([.banner, .sound, .badge])
      }
    
    
}

