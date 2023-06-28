//
//  PlaylistModel.swift
//  MusicApp
//
//  Created by Ranvir Singh Virk on 4/14/23.
//

import Foundation

class PlaylistModel{
    var playlists: [Playlist]
    
    init(){
        playlists = []
    }
    
    func empty(){
        self.playlists = []
    }
    
    func configerPlaylists(){
        var playlistName = ""
        
        let fileManager = FileManager.default
        let playlistsDirectoryPath = Bundle.main.resourcePath?.appending("/Music/Playlist")
        
        do{
            let playlistsNames = try fileManager.contentsOfDirectory(atPath: playlistsDirectoryPath!)
            for playlistsName in playlistsNames{
                let component = playlistsName.components(separatedBy: "-")
                playlistName = component[0]
                
//                self.playlists.append(Playlist(
//                    songName: playlistName,
//                    // trying to figure out how we should configure the playlist functionality in
//                    // file system.
//                    // songs:
//                ))
            }
        }
        catch{
            print(error)
        }
    }
}

struct Playlist{
    let playlistName: String?
    let songs: [Song]
    let cover = "Cover"
}
