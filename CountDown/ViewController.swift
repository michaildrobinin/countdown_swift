import UIKit
import UserNotifications
import GoogleMobileAds
import AudioToolbox

class ViewController: UIViewController, UITableViewDelegate, GADBannerViewDelegate, UITableViewDataSource
{
   
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3467593785713121/2406757797"
    var adMobBannerView = GADBannerView()
    let defaults = UserDefaults.standard
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appDelegate.events.count
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullPageViewControllerID") as! FullPageViewController
        appDelegate.currentIndex = indexPath.row
        vc.model = appDelegate.events[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    var timer: Timer?
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let model = appDelegate.events[indexPath.row]
        cell.titleLabel?.text = model.title
        cell.subtitleLabel?.text = model.getString()
        cell.backImage.image = model.image
        
        cell.clipsToBounds = false
        let s = cell.content1View
        s?.backgroundColor = UIColor.clear
        s?.layer.shadowColor = UIColor.black.cgColor
        s?.layer.shadowOffset = CGSize(width: 0, height: 0)
        s?.layer.shadowOpacity = 0.7
        s?.layer.shadowRadius = 5.0
        
        let c = cell.cellView
        c?.frame = (s?.bounds)!
        c?.layer.cornerRadius = 15
        c?.layer.borderColor = UIColor.black.cgColor
        c?.layer.borderWidth = 0.0
        c?.layer.masksToBounds = true
        s?.addSubview(c!)
        
        cell.model = model
        return cell
    }
    @objc func tick(timer: Timer) {
        var tableCount = appDelegate.events.count
        var index = 0
        while index < tableCount {
            let model = self.appDelegate.events[index]
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? CustomTableViewCell
            if cell == nil {
                continue
            }
            cell?.subtitleLabel.text = model.getString()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if (cell?.subtitleLabel.text?.contains("-"))! && delegate.autoRemove {
                delegate.events.remove(at: index)
                delegate.save()
                delegate.mainVC?.tableView.reloadData()
                tableCount = tableCount - 1
            }
            index = index + 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        initAdMobBanner()
        if defaults.bool(forKey: "Purchased")
        {
            hideBanner(adMobBannerView)
        }
        else if defaults.bool(forKey: "Restored")
        {
            showBanner(adMobBannerView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        GlobalVariable.app_icon_badgeStatus = appDelegate.autoBadge
        if GlobalVariable.app_icon_badgeStatus {
            let application = UIApplication.shared
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound])  {
                (granted, error) in
            }
            application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = self.appDelegate.minDay
//            if (self.appDelegate.minDay == 0) {
//                GlobalVariable.app_icon_badgeStatus = false
//            }
        }
    }
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }

}

