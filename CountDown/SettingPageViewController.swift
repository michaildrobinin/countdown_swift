import UIKit
import SelectionDialog
import StoreKit
import GoogleMobileAds
import AudioToolbox
import SwiftCheckboxDialog

class SettingPageViewController: UIViewController, GADBannerViewDelegate, CheckboxDialogViewDelegate
{
    typealias TranslationTuple = (name: String, translated: String)
    typealias tUnits = [String]
    var checkboxDialogViewController: CheckboxDialogViewController!
    let type: Int! = 1
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3467593785713121/2406757797"
    var adMobBannerView = GADBannerView()
    let defaults = UserDefaults.standard
    @IBAction func cancel_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var autoRemoveSwitch: UISwitch!
    @IBOutlet weak var autoBadgeStatus: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        autoRemoveSwitch.setOn(appDelegate.autoRemove, animated: true)
        autoBadgeStatus.setOn(appDelegate.autoBadge, animated: true)
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
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
    @IBAction func badge_status(_ sender: UISwitch)
    {
        self.appDelegate.autoBadge = sender.isOn
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(sender.isOn, forKey: "badge")
    }
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBAction func count_units(_ sender: UIButton)
    {
//
//        let dialog = SelectionDialog(title: "Dialog", closeButtonTitle: "Close")
//        dialog.addItem(item: "Days", didTapHandler: { ()
//            self.appDelegate.dateType = 1
//            dialog.close()
//        })
//        dialog.addItem(item: "Hours", didTapHandler: { () in
//            self.appDelegate.dateType = 2
//            dialog.close()
//        })
//        dialog.addItem(item: "Minutes", didTapHandler: { () in
//            self.appDelegate.dateType = 3
//            dialog.close()
//        })
//        dialog.addItem(item: "Seconds", didTapHandler: { () in
//            self.appDelegate.dateType = 4
//            dialog.close()
//        })
//        dialog.show()
        let tableData :[(name: String, translated: String)] = [("Days", "Days"),
                                                               ("Hours", "Hours"),
                                                               ("Minutes", "Minutes"),
                                                               ("Seconds", "Seconds")]
        
        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "Units"
        self.checkboxDialogViewController.tableData = tableData
        self.checkboxDialogViewController.defaultValues = [tableData[0],tableData[1],tableData[2],tableData[3]]
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.countries
        self.checkboxDialogViewController.delegateDialogTableView = self
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
        
    }
    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        let day = values.keys.contains("Days")
        let hour = values.keys.contains("Hours")
        let min = values.keys.contains("Minutes")
        let sec = values.keys.contains("Seconds")
        if !day && !hour && !min && sec
        {
            self.appDelegate.dateType = 1
            print("Great")
        }
        if !day && !hour && min && !sec
        {
            self.appDelegate.dateType = 2
            print("Great")
        }
        if !day && !hour && min && sec
        {
            self.appDelegate.dateType = 3
            print("Great")
        }
        if !day && hour && !min && !sec
        {
            self.appDelegate.dateType = 4
            print("Great")
        }
        if !day && hour && !min && sec
        {
            self.appDelegate.dateType = 5
            print("Great")
        }
        if !day && hour && min && !sec
        {
            self.appDelegate.dateType = 6
            print("Great")
        }
        if !day && hour && min && sec
        {
            self.appDelegate.dateType = 7
            print("Great")
        }
        if day && !hour && !min && !sec
        {
            self.appDelegate.dateType = 8
            print("Great")
        }
        if day && !hour && !min && sec
        {
            self.appDelegate.dateType = 9
            print("Great")
        }
        if day && !hour && min && !sec
        {
            self.appDelegate.dateType = 10
            print("Great")
        }
        if day && !hour && min && sec
        {
            self.appDelegate.dateType = 11
            print("Great")
        }
        if day && hour && !min && !sec
        {
            self.appDelegate.dateType = 12
            print("Great")
        }
        if day && hour && !min && sec
        {
            self.appDelegate.dateType = 13
            print("Great")
        }
        if day && hour && min && !sec
        {
            self.appDelegate.dateType = 14
            print("Great")
        }
        if day && hour && min && sec
        {
            self.appDelegate.dateType = 15
            print("Great")
        }
    }
    @IBAction func autoRemoveChanged(_ sender: UISwitch) {
        self.appDelegate.autoRemove = sender.isOn
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(sender.isOn, forKey: "remove")
    }
    @IBAction func remove_ads(_ sender: UIButton) {
        Products.store.buyProduct(appDelegate.products[0])
    }
    @IBAction func restore_purchase(_ sender: UIButton) {
        Products.store.restorePurchases()
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
