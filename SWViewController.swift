
import UIKit

class SWViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var displayTimeLabel: UILabel!
    
    var laps:[String] = []
    
    var startTime = NSTimeInterval()
    
    var timer:NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapsTableView.dataSource = self
        lapsTableView.backgroundColor = UIColor(red: 0, green: 116, blue: 254, alpha: 0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lapsTableView.dequeueReusableCellWithIdentifier("prototype1", forIndexPath: indexPath)
        cell.textLabel?.text = laps[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        return cell
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            laps.removeAtIndex(indexPath.row)
            lapsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    
    @IBAction func start(sender: UIButton) {
        if (displayTimeLabel.text == "00:00:00") {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        timer.invalidate()
        _ = sender.titleForState(UIControlState.Normal)!
        if(sender.currentTitle == "Reset"){
            
            
            func reset(){
                sender.setTitle("Stop", forState: UIControlState.Normal)
                self.displayTimeLabel.text = "00:00:00"
                self.laps = []
                self.lapsTableView.reloadData()
            }
            
            
            let title = "Are you sure you want to Reset?"
            let message = "All laps will be deleted"
            let okText = "Yes"
            let cancelText = "No"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelButton = UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelButton)
            let okButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Destructive, handler: nil)
            alert.addAction(okButton)
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
        else{sender.setTitle("Reset", forState: UIControlState.Normal)}
    }
    
    @IBAction func lap(sender: UIButton) {
        if(displayTimeLabel.text != "00:00:00"){
            laps.insert(displayTimeLabel.text!, atIndex: 0)
            lapsTableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}