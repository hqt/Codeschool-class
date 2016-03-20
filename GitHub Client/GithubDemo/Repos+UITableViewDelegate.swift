//
//  Repos+UITableViewDelegate.swift
//  GithubDemo
//
//  Created by Huynh Quang Thao on 3/16/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

extension RepoResultsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.hqt.github.cell", forIndexPath: indexPath) as! GitHubCell
        let repo = repos[indexPath.row]
        
        cell.projectTitleLabel.text = repo.name
        cell.authorLabel.text = repo.ownerHandle
        cell.projectDescriptionLabel.text = repo.repoDescription
        cell.starCountLabel.text = String(repo.stars!)
        cell.forkCountLabel.text = String(repo.forks!)
        
        let url = NSURL(string: repo.ownerAvatarURL!)
        cell.projectImageView.setImageWithURL(url!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    // remove background when click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }


    

}
