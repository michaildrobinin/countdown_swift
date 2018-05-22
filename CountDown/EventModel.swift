import UIKit

class EventModel : NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(image, forKey: "image")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let image = aDecoder.decodeObject(forKey: "image") as! UIImage
        self.init(title, date, image)
    }
    
    open var title : String! = ""
    open var date: Date! = Date()
    open var image: UIImage! = UIImage()
    
    init(_ title: String, _ date: Date, _ image: UIImage) {
        self.title = title
        self.date = date
        self.image = image        
    }
    
    func getDateString() -> String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df.string(from: date)
    }
    
    func getString() -> String {
        let delegate = (UIApplication.shared.delegate as! AppDelegate)
        let type = delegate.dateType!
        let interval = Int(date.timeIntervalSinceNow)
        let second = interval % 60
        let minute = (interval / 60) % 60
        let hour = ((interval / 3600) % 24)
        let day = interval / 86400
        if (day < delegate.minDay) {
            delegate.minDay = day
            let defaults:UserDefaults = UserDefaults.standard
            defaults.set(day, forKey: "day")
        }
        
        switch type
        {
            case 1:
                return String.init(format: "%d Secs", day * 86400 + hour * 3600 + minute * 60 + second)
            case 2:
                return String.init(format: "%d Mins", day * 1440 +  hour * 60 + minute)
            case 3:
                return String.init(format: "%d Mins %d Secs", day * 1440 +  hour * 60 + minute, second)
            case 4 :
                return String.init(format: "%d Hours", day * 24 + hour)
            case 5:
                return String.init(format: "%d Hours %d Secs", day * 24 + hour, minute * 60 + second)
            case 6:
                return String.init(format: "%d Hours %d Mins", day * 24 + hour, minute)
            case 7:
                return String.init(format: "%d Hours %d Mins %d Secs", day * 24 + hour, minute, second)
            case 8:
                return String.init(format: "%d Days", day)
            case 9:
                return String.init(format: "%d Days %d Secs", day, hour * 3600 + minute * 60 + second)
            case 10:
                return String.init(format: "%d Days %d Mins", day, hour * 60 + minute)
            case 11:
                return String.init(format: "%d Days %d Mins %d Secs", day, hour * 60 + minute, second)
            case 12:
                return String.init(format: "%d Days %d Hours", day, hour)
            case 13:
                return String.init(format: "%d Days %d Hours %d Secs", day, hour, minute * 60 + second)
            case 14:
                return String.init(format: "%d Days %d Hours %d Mins", day, hour, minute)
            case 15:
                return String.init(format: "%d Days %d Hours %d Mins %d Secs", day, hour, minute, second)

            default:
                return String.init(format: "%d Days %d Hours %d Mins %d Secs", day, hour, minute, second)
            
        }
    }
}
