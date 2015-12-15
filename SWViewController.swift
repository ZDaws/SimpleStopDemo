
import UIKit

class SWViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var displayTimeLabel: UILabel!
    
    var laps:[String] = []
    
    var startTime = NSTimeInterval()
    
    var saveTime: String = "00.00.00"
    
    var DateFormatter = NSDateFormatter()
    
    var newStartTime = NSDate()
    
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
            //makes a new timer where the time updates every .01 seconds
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        else {
            let bSelector : Selector = "updateTime"
            //starts timer from current time
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: bSelector, userInfo: nil, repeats: true)
            if (self.saveTime != NSNull()) {
                //take the displayLabel from the timer and turn it into a NSDate() object
                newStartTime = DateFormatter.dateFromString(saveTime)!
                startTime = newStartTime.timeIntervalSinceDate(newStartTime) //use the new date to start the timer at "endTime"
            }
        }
        
    }
    
    @IBAction func stop(sender: UIButton) {
        timer.invalidate() //stops the timer
        _ = sender.titleForState(UIControlState.Normal)!
        if(sender.currentTitle == "Reset"){ //if the button title is "Reset", then show the alert when pressed
            sender.setTitle("Stop", forState: UIControlState.Normal) //sets title of the button back to "Stop"
            let title = "Are you sure you want to reset?"
            let message = "All laps will be deleted!"
            let okText = "Yep"
            let cancelText = "Nope"
            
            //resets the master clock and deletes all laps
            let reset = { (action:UIAlertAction!) -> Void in
                self.displayTimeLabel.text = "00:00:00"
                self.laps = []
                self.lapsTableView.reloadData()
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert) //new alert
            
            let cancelButton = UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: nil) //cancels the reset
            alert.addAction(cancelButton)
            let okButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Destructive, handler: reset) //calls the reset function
            alert.addAction(okButton)
            
            presentViewController(alert, animated: true, completion: nil) //present the alert when the "Reset" button is pressed
            
        }
        else{
            sender.setTitle("Reset", forState: UIControlState.Normal)
            self.saveTime = displayTimeLabel.text!
        } //if the button title is "Stop", then change the title to reset and saveTime is the time it was stopped at.
    }
    
    @IBAction func lap(sender: UIButton) {
        if(displayTimeLabel.text != "00:00:00"){
            laps.insert(displayTimeLabel.text!, atIndex: 0) //record the displayTimeLabel (the time) and insert it into the "laps" array
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