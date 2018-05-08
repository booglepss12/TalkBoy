//
//  ItemTableViewController.swift
//  TalkBoy
//
//  Created by John Rooney on 2018-05-04.
//  Copyright © 2018 John Rooney. All rights reserved.
//

import UIKit
import AVFoundation

class ItemTableViewController: UITableViewController {
    var sounds:[Sound] = []
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
     //getting sounds from core data
       func getSounds(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            if let tempSounds = try? context.fetch(Sound.fetchRequest()) as? [Sound]{
                if let theSounds = tempSounds{
                    sounds = theSounds
                    tableView.reloadData()
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let sound = sounds[indexPath.row]
        if let audioData = sound.audioData{
        audioPlayer = try? AVAudioPlayer(data: audioData)
        audioPlayer?.play()
            
        }
        //deselects row after plays audio
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSounds()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sound = sounds[indexPath.row]
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                context.delete(sound)
                getSounds()
            }
        
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
 

}
