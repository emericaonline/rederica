//
//  SubredditViewController.swift
//  reddit
//
//  Created by Jonathan Tran on 2/13/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SubredditViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)

        // Register cell classes
        self.collectionView?.register(itemCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? itemCell
        // Configure the cell
        switch indexPath.item {
        case 0:
           cell?.itemLabel.text = "Frontpage"
           break;
        case 1:
            cell?.itemLabel.text = "All subreddits"
            break;
        case 2:
            cell?.itemLabel.text = "mfa"
            break;
        case 3:
            cell?.itemLabel.text = "Select Subreddit"
            break;
        case 4:
            cell?.itemLabel.text = "Login"
            break;
        case 5:
            cell?.itemLabel.text = "Logout"
            break;
        default:
            cell?.itemLabel.text = ""
        }
    
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if (indexPath.item == 0) {
            let feedController = FeedController()
            navigationController?.pushViewController(feedController, animated: true)
        }
        else if (indexPath.item == 1) {
            let feedController = FeedController(subreddit: "all")
            navigationController?.pushViewController(feedController, animated: true)
        }
        else if (indexPath.item == 2) {
            let feedController = FeedController(subreddit: "malefashionadvice")
            navigationController?.pushViewController(feedController, animated: true)
        }
        
        else if (indexPath.item == 3) {
            let selectSubredditController = chooseSubredditController()
            navigationController?.pushViewController(selectSubredditController, animated: true)
        }
        else if (indexPath.item == 4) {
            let string: String = "https://ssl.reddit.com/api/v1/authorize?client_id=HIDDENFORREASONS&response_type=code&state=TEST&redirect_uri=rederica://response&duration=permanent&scope=read,identity"
            let vc = WebViewController(url: string);
            navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.item == 5) {
            let redAPI = RedditAPI()
            redAPI.logout()
        }
        
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    

}


class itemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        return itemLabel
    } ()
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(itemLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: itemLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: itemLabel)
    }
}
