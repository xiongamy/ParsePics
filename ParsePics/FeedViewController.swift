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
    @IBOutlet weak var detailContainerView: UIView!
    
    let queryLimit = 20
    let detailViewAnimationDuration = 0.2
    
    var posts: [PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main view loaded")
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 400
        feedTableView.rowHeight = UITableViewAutomaticDimension

        let options = NSKeyValueObservingOptions([.New, .Old])
        detailContainerView.addObserver(self, forKeyPath: "hidden", options: options, context: nil)

        
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
    
    // Triggers when the detailContainerView becomes hidden & not hidden.
    /*override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if detailContainerView.hidden == false {
            print("unhidden")
            let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier(ViewControllers.detail) as! DetailViewController
            //detailVC.loadData()
        }
    }*/
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("main view appeared")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes query
    // Also the pull-to-refresh function
    // Loads extra data when refreshControl is nil
    func makeQuery(refreshControl: UIRefreshControl?) {
        
        print("refreshing")
        
        var atBottom: Bool = false
        
        let query = setQueryProperties()
        
        if refreshControl == nil && posts != nil {
            atBottom = true
            query.skip = posts!.count
            print("skipping")
        }
        
        if posts != nil {
            print(posts!.count)
        } else {
            print(0)
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
        //query.includeKey("createdAt")
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numCells = 0
        
        if posts != nil {
            numCells = (self.posts?.count)!
        }
        
        return numCells
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        if posts != nil {
            let post = posts![indexPath.row]
            cell.post = post
        }
        
        return cell
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let userVC = self.storyboard!.instantiateViewControllerWithIdentifier(ViewControllers.login)
                self.presentViewController(userVC, animated: true, completion: nil)
                
                
                print("Logged out!")
            }
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
        /*let tapRecognizer = sender as! UITapGestureRecognizer
        let tapLocation = tapRecognizer.locationInView(self.feedTableView)
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        if let tappedIndexPath = self.feedTableView.indexPathForRowAtPoint(tapLocation) {
            if let tappedCell = self.feedTableView.cellForRowAtIndexPath(tappedIndexPath) {
                let indexPath = self.feedTableView.indexPathForCell(tappedCell)
                /*if posts != nil {
                 let tryPosts = posts
                 let post = tryPosts![indexPath!.row]
                 
                 detailVC.post = post
                 }*/
                
                //detailVC.rowNumber = indexPath!.row
                
                if self.posts != nil {
                    detailViewController.post = self.posts![indexPath!.row]
                }
            }
        }*/
        
        
    }*/
    

    @IBAction func tapPhoto(sender: AnyObject) {
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier(ViewControllers.detail) as! DetailViewController
        
        self.addChildViewController(detailVC)
        
        print("tapped")
        
        let tapRecognizer = sender as! UITapGestureRecognizer
        let tapLocation = tapRecognizer.locationInView(self.feedTableView)
        
        /*UIView.animateWithDuration(detailViewAnimationDuration, animations: {
            self.detailContainerView.alpha = 1.0
            self.detailContainerView.hidden = false
            }, completion: { (success) in*/
        
        if let tappedIndexPath = self.feedTableView.indexPathForRowAtPoint(tapLocation) {
            if let tappedCell = self.feedTableView.cellForRowAtIndexPath(tappedIndexPath) {
                let indexPath = self.feedTableView.indexPathForCell(tappedCell)
                /*if posts != nil {
                    let tryPosts = posts
                    let post = tryPosts![indexPath!.row]
                 
                    detailVC.post = post
                }*/
                
                //detailVC.rowNumber = indexPath!.row
                
                //detailVC.captionLabel.text = "Hiiiii"
                
                print(indexPath!.row)
                
                if self.posts != nil {
                    let post = self.posts![indexPath!.row]
                    detailVC.post = post
                }
                
                //detailVC.loadData()
                
                print("data sent!")
            }
                }/*})*/
        detailVC.view.frame = detailContainerView.frame
        
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.addSubview(detailVC.view)}, completion: nil)
        
        
        detailVC.didMoveToParentViewController(self)
       
        
        //fadeInDetailView()
    }
    
    func fadeInDetailView() {
        UIView.animateWithDuration(detailViewAnimationDuration, animations: {
            self.detailContainerView.alpha = 1.0
            self.detailContainerView.hidden = false
        })
    }
    
    func fadeOutDetailView() {
        UIView.animateWithDuration(detailViewAnimationDuration, animations: {
            self.detailContainerView.alpha = 0.0
            }, completion: { (success) in
                self.detailContainerView.hidden = true
        })
    }
}
