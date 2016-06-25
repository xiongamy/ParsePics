//
//  FeedViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/20/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var feedTableView: UITableView!
    
    let queryLimit = 20
    let detailViewAnimationDuration = 0.2
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    var posts: [PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 400
        feedTableView.rowHeight = UITableViewAutomaticDimension

        // Register header view nib
        let nib = UINib(nibName: "FeedSectionHeader", bundle: nil)
        feedTableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "FeedSectionHeader")
        
        // Set up infinite scroll loading indicator
        let frame = CGRectMake(0, feedTableView.contentSize.height, feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        feedTableView.addSubview(loadingMoreView!)
        
        var insets = feedTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        feedTableView.contentInset = insets
        
        // Set up pull-to-refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(makeQuery(_:)), forControlEvents: UIControlEvents.ValueChanged)
        feedTableView.insertSubview(refreshControl, atIndex: 0)
        
        makeQuery(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Makes query
    // Also the pull-to-refresh function
    // Loads extra data when refreshControl is nil
    func makeQuery(refreshControl: UIRefreshControl?) {
        
        var atBottom: Bool = false
        
        let query = setQueryProperties()
        
        if refreshControl == nil && posts != nil {
            atBottom = true
            query.skip = posts!.count
        }
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                
                if atBottom {
                    self.posts?.appendContentsOf(posts)
                } else {
                    self.posts = posts
                }
                
                self.feedTableView.reloadData()
                if refreshControl != nil && refreshControl!.refreshing {
                    refreshControl!.endRefreshing()
                }
            } else {
                print("error")
            }
            
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
        }
    }
    
    func setQueryProperties() -> PFQuery {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = queryLimit
        
        return query
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = feedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - feedTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && feedTableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, feedTableView.contentSize.height, feedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Load more data
                makeQuery(nil)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numCells = 0
         
         if posts != nil {
         numCells = (self.posts?.count)!
         }
         
         return numCells
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.post, forIndexPath: indexPath) as! PostCell
        cell.selectionStyle = .None
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        cell.photoView.userInteractionEnabled = true
        cell.photoView.addGestureRecognizer(tapRecognizer)
        
        if posts != nil {
            let post = posts![indexPath.section]
            cell.post = post
                        
        }
        
        return cell
    }
    
    func onTap(sender: AnyObject?) {
        performSegueWithIdentifier("detailSegue", sender: sender)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FeedSectionHeader")! as! FeedSectionHeader
        
        if posts != nil {
            let post = posts![section]
            header.post = post
        }
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let userVC = self.storyboard!.instantiateViewControllerWithIdentifier(ViewControllers.login)
                self.presentViewController(userVC, animated: true, completion: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as! DetailViewController
        
        let tapRecognizer = sender as! UITapGestureRecognizer
        let tapLocation = tapRecognizer.locationInView(self.feedTableView)
        
        if let tappedIndexPath = self.feedTableView.indexPathForRowAtPoint(tapLocation) {
            if self.posts != nil {
                let post = self.posts![tappedIndexPath.section]
                detailVC.post = post
            }
        }
    }
}
