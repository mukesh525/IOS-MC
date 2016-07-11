import UIKit
@objc protocol FilterSelectedDelegate {
    func filterSelected(position: Int)
}

class menuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var SeletedFilter: Int=0;
    weak var delegate: FilterSelectedDelegate?
    var currentPopover:UIPopoverController!
    var FilterOptions = [OptionsData]()
    
    @IBOutlet weak var myTableView: UITableView!
   
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
//    }
    
    
    override func viewWillAppear(animated: Bool) {
      self.preferredContentSize=myTableView.contentSize;    }
    
    override func viewDidAppear(animated: Bool) {

        let myPath = NSIndexPath(forRow: SeletedFilter, inSection: 0)
        myTableView.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)}
        
    

    @IBOutlet weak var tableView: UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return FilterOptions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.filterSelected(indexPath.item)        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let option: OptionsData = self.FilterOptions[indexPath.row] 
        
        // let isMutableArray = self.FilterOptions[indexPath.row] is OptionsData
        //print("Results and \(isMutableArray)")
     cell.textLabel!.text = option.value
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UIView()
        //self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
