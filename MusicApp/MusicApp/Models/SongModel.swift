//
//  SongModel.swift
//  MusicApp
//
//  Created by Ranvir Singh Virk on 4/13/23.
//Jonathon Mangan jonmanga@iu.edu
//Ranvir Virk rsvirk@iu.edu
//Sanmeet Singh ss140@iu.edu
//Music Player app
//Submitted: 04/28/2023

import Foundation
// Refferences from stackoverflow, and apple documentation
// https://stackoverflow.com/questions/25678373/split-a-string-into-an-array-in-swift
// https://developer.apple.com/documentation/foundation/bundle

class SongModel: NSObject, Codable{
    var songs: [Song]
    
    override init(){
        self.songs = []
    }
    
    func empty(){
        self.songs = []
    }
    
    func configerSongs(){
        if self.songs.count > 0{
            return
        }
        var songName = ""
        var artistName = ""
        var songPosition = 0
        
        let fileManager = FileManager.default
        let songsDirectoryPath = Bundle.main.resourcePath?.appending("/Music")
        
        do{
            let songFileNames = try fileManager.contentsOfDirectory(atPath: songsDirectoryPath!)
            for songFileName in songFileNames{
                let component = songFileName.components(separatedBy: "-")
                songName = component[0]
                artistName = component[1].components(separatedBy: ".")[0]
                songPosition = self.songs.count
                
                self.songs.append(Song(
                    songName: songName,
                    artistName: artistName,
                    trackName: songFileName,
                    songPosition: songPosition
                ))
            }
        }
        catch{
            print(error)
        }
    }
}

struct Song: Codable{
    let songName: String?
    let artistName: String?
    let trackName: String?
    var coverName = "Cover"
    let songPosition: Int?
    var liked: Bool = false
}
