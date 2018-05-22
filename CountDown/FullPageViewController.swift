import UIKit
import GoogleMobileAds
import AudioToolbox
class FullPageViewController: UIViewController,GADBannerViewDelegate{
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        count = appDelegate.events.count
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
    var timer: Timer?
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3467593785713121/2406757797"
    var adMobBannerView = GADBannerView()
    
    @objc func tick() {
        self.subTitleIA.text = self.model?.getString()
    }

    @IBAction func cancel_btn(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        self.dismiss(animated: true, completion: nil)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var count:Int = 0
    var model: EventModel?
    @IBOutlet weak var fullImage: UIImageView!
    
    @IBOutlet weak var titleIA: UILabel!
    @IBOutlet weak var subTitleIA: UILabel!
    
    @IBAction func edit_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPageViewControllerID") as! EditPageViewController
        vc.model = appDelegate.events[appDelegate.currentIndex]
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.count != self.appDelegate.events.count) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        model = appDelegate.events[appDelegate.currentIndex]
        fullImage.image = model?.image
        titleIA.text = model?.title
        subTitleIA.text = model?.getString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnShareClicked(_ sender: Any) {
        let textToShare = "Let me recommend you this application"
        let myWebsite = "itunes.apple.com/us/app/strat-roulette-hub/id1348767186?&mt=8"
        let objectsToShare = [textToShare, myWebsite]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
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
    func adViewDidReceiveAd(_ view: GADBannerView!) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        hideBanner(adMobBannerView)
    }
}
