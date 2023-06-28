//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Ranvir Singh Virk on 4/13/23.
//Jonathon Mangan jonmanga@iu.edu
//Ranvir Virk rsvirk@iu.edu
//Sanmeet Singh ss140@iu.edu
//Music Player app
//Submitted: 04/28/2023

import UIKit

class SearchViewController: UITabBarController, UISearchBarDelegate{
    
    
    var appDeligate: AppDelegate?
    var myModelRef: SongModel?
    
    var indexOfPlay: [Int] = []
    let DEFAULT = ""
    
    var songModel: SongModel?
    var findings: [String] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize your SongModel object
        self.myModelRef = SongModel()
        
        // Add a search bar to the view
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Songs"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        // Add constraints to the search bar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//         Add a table view to the view
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Add constraints to the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myModelRef?.empty()
        let tempModel = SongModel()
        tempModel.configerSongs()
        for song in tempModel.songs{
            if song.songName?.contains(searchText) ?? false{
                self.myModelRef?.songs.append(song)
                indexOfPlay.append(tempModel.songs.firstIndex(where: { $0.songName == song.songName })!)
                print(song)
                tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = DEFAULT
        self.myModelRef!.empty()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

// Implement the UITableViewDataSource methods
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myModelRef?.songs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTableViewCell
        let song = myModelRef?.songs[indexPath.row]
        cell.song = song
        cell.textLabel?.text = "\(song?.songName ?? "") - \(song?.artistName ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController{
            guard let cell = tableView.cellForRow(at: indexPath) as? SongTableViewCell else{
                return
            }
            vc.songNumber = (cell.song?.songPosition)!
            present(vc, animated: true)
        } else{
            return
        }
    }
}
