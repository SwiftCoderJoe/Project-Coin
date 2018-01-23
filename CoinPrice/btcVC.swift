import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView

class btcVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variable declaration */
    
    
    var pastString:String = ""
    var todayString:String = ""
    var bitcoinHistory = [Double]()
    typealias DownloadComplete = () -> ()
    private var currBtnPressed:String = ""
    private var btcPrice: Double = -1
    private let currencies = ["USD", "EUR", "GBP"]
    var chartLength = 50
    let todaysDate:NSDate = NSDate()
    
    
    /* IBOutlets */
    
    
    @IBOutlet weak var btcPriceLabel: UILabel!
    @IBOutlet weak var chartLoad: NVActivityIndicatorView!
    @IBOutlet weak var currView: UIView!
    @IBOutlet weak var currencyPick: UITableView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var calcCurrencyPick1: UIButton!
    @IBOutlet weak var calcCurrencyPick2: UIButton!
    @IBOutlet weak var priceCurrencyPick: UIButton!
    @IBOutlet weak var calcView: UIView!
    @IBOutlet weak var calcBTN: UIButton!
    @IBOutlet weak var priceBTN: UIButton!
    @IBOutlet weak var btcChart: LineChartView!

    
    /* IBActions */
    
    
    @IBAction func pricePressed(_ sender: Any) {
        calcView.isHidden = true
        priceView.isHidden = false
        priceBTN.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        calcBTN.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
    }
    
    @IBAction func calcCurrPick1Prsd(_ sender: Any) {
        currBtnPressed = "calc1"
        currView.isHidden = false
    }
    
    @IBAction func calcCurr2Prsd(_ sender: Any) {
        currBtnPressed = "calc2"
        currView.isHidden = false
    }
    
    @IBAction func priceCurrPickPrsd(_ sender: Any) {
        currBtnPressed = "price"
        currView.isHidden = false
    }
    
    @IBAction func calcPressed(_ sender: Any) {
        calcView.isHidden = false
        priceView.isHidden = true
        priceBTN.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        calcBTN.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")

    }
    
    
    /* User-defined functions */
    
    func downloadBTCdata(completion: @escaping () -> Void) {
        var url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        Alamofire.request(url).responseJSON { response in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, AnyObject> {
                    if let usd = bpi["USD"] as? Dictionary<String, AnyObject> {
                        print(usd["rate_float"]!)
                        self.btcPrice = usd["rate_float"]! as! Double
                        print(self.btcPrice)
                    }
                }
            }
        }
        
        url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(self.pastString)&end=\(self.todayString)")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        Alamofire.request(url).responseJSON {response in
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, Double> {
                    for i in 0...self.chartLength {
                        let btcAdd1:String = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -(self.chartLength-i), to: Date())!)
                        let btcAdd2 = bpi[btcAdd1]
                        self.bitcoinHistory.append(btcAdd2!)
                        print(self.bitcoinHistory)
                    }
                }
            }
        }
        completion()
    }
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<bitcoinHistory.count {
            let value = ChartDataEntry(x: Double(i), y: bitcoinHistory[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Coinrprice")
        line1.circleRadius = CGFloat(4.0)
        line1.circleHoleRadius = CGFloat(2.0)
        line1.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        btcChart.data = data
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func chartAsync() -> Void {
        if self.bitcoinHistory.count != self.chartLength + 1 || self.btcPrice == -1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.chartAsync()
            }
            btcChart.isHidden = true
        } else {
            btcPriceLabel.text = "$\(btcPrice)"
            btcChart.isHidden = false
            updateGraph()
            chartLoad.isHidden = true
            chartLoad.stopAnimating()
        }
    }
    
    
    /* Protocol functions */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = currencies[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currBtnPressed == "calc1" {
            calcCurrencyPick1.setTitle(currencies[indexPath.row], for: UIControlState.normal)
        } else if currBtnPressed == "calc2"{
            calcCurrencyPick2.setTitle(currencies[indexPath.row], for: UIControlState.normal)
        } else {
            priceCurrencyPick.setTitle(currencies[indexPath.row], for: UIControlState.normal)
        }
        currView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPick.dataSource = self
        currencyPick.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        todayString = dateFormatter.string(from: todaysDate as Date)
        pastString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -chartLength, to: Date())!)
        currencyPick.tableFooterView = UIView()
        chartLoad.color = UIColor.darkGray
        chartLoad.startAnimating()
        currencyPick.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        downloadBTCdata{}
        btcChart.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.chartAsync()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
