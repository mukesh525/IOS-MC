import UIKit

@objc protocol FilterSelectedDelegate {
    func filterSelected(_ position: Int)
}

class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var SeletedFilter: Int=0;
    weak var delegate: FilterSelectedDelegate?
    //var currentPopover1:UIPopoverController!
    var FilterOptions = [OptionsData]()
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
    // self.preferredContentSize=myTableView.contentSize;
    }
    
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let myPath = IndexPath(row: SeletedFilter, section: 0)
        myTableView.selectRow(at: myPath, animated: false, scrollPosition: UITableViewScrollPosition.none)}
    
    
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.dismiss(animated: true, completion: nil)
        delegate?.filterSelected((indexPath as NSIndexPath).item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let option: OptionsData = self.FilterOptions[(indexPath as NSIndexPath).row]
        
        //print("Results and \(isMutableArray)")
        cell.textLabel!.text = option.value
        cell.textLabel!.font = cell.textLabel!.font.withSize(15)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UIView()
        self.preferredContentSize = CGSize(width: 200, height: FilterOptions.count*44)
        //self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
