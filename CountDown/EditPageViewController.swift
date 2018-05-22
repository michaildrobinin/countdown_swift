import UIKit
import GoogleMobileAds
import AudioToolbox
class EditPageViewController: UIViewController,GADBannerViewDelegate {
    
    var model : EventModel?
    var pickedDate: Date! = Date()
    var inputViews: UIView?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3467593785713121/2406757797"
    let defaults = UserDefaults.standard
    var adMobBannerView = GADBannerView()
    @IBAction func cancel_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var dateBottom: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var date_btn: UIButton!
    @IBOutlet weak var event_btn: UITextField!
    @IBOutlet weak var gh: UIView!
    @IBOutlet weak var cam_btn: UIButton!
    var currentVC : UIViewController?
    static let shared  = AddPageViewController()
    var imagePickedBlock: ((UIImage) -> Void)?
    var up: Bool! = false
    @IBAction func cam_btn_clicked(_ sender: Any) {
        showActionSheet(vc: self)
        
    }
    @IBAction func cam_btn1_clicked(_ sender: Any) {
        showActionSheet(vc: self)
    }
    @IBAction func showDatePicker(_ sender: UIButton) {
        if !up {
            dateBottom.constant -= 240
            up = true
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func handleDatePicker(_ sender: UIDatePicker) {
    }
    
    @IBAction func doneButton(_ sender:UIButton) {
        model?.date = datePicker.date
        self.date_btn.setTitle(model?.getDateString(), for: .normal)
        
        if up {
            dateBottom.constant += 240
            up = false
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelButton(_ sender:UIButton) {
        if up {
            dateBottom.constant += 240
            up = false
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showActionSheet(vc: UIViewController)
    {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    @IBAction func add_btn(_ sender: Any)
    {
        model?.title = event_btn.text!
        appDelegate.events[appDelegate.currentIndex] = model!
        dismiss(animated: true, completion: nil)
    }
    @IBAction func remove_btn(_ sender: UIButton) {
        appDelegate.events.remove(at: appDelegate.currentIndex)
        appDelegate.save()
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dateBottom.constant += 240
        up = false
        self.view.layoutIfNeeded()
        cam_btn.setImage(model?.image, for: .normal);
//        gh.clipsToBounds = true
        gh.backgroundColor = UIColor.clear
        gh.layer.shadowColor = UIColor.black.cgColor
        gh.layer.shadowOffset = CGSize(width: 0, height: 0)
//        gh.layer.shadowOpacity = 0.7
//        gh.layer.shadowRadius = 5.0
        cam_btn.frame = (gh.bounds)
        cam_btn.layer.cornerRadius = 15
        cam_btn.layer.borderColor = UIColor.black.cgColor
        cam_btn.layer.borderWidth = 0.0
        cam_btn.layer.masksToBounds = true
        gh.addSubview(cam_btn!)
        date_btn.setTitle(model?.getDateString(), for: .normal)
        event_btn.text = model?.title
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
//        cam_btn.layer.cornerRadius = 10
//        cam_btn.clipsToBounds = false
        cam_btn.setImage(model?.image, for: .normal)
        date_btn.setTitle(model?.getDateString(), for: .normal)
        event_btn.text = model?.title
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
extension EditPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            model?.image = image
            self.cam_btn.setImage(image, for: UIControlState.normal)
        }else{
            print("Something went wrong")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
}
