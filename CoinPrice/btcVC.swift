import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView


var currentCurr = "USD"
let symbols = ["USD":"$", "EUR":"€", "GBP":"£"]

class btcVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    /* Global variable declaration */
    
    var lastCurrPressed = "price"
    var pastString:String = ""
    var todayString:String = ""
    var bitcoinHistory = [Double]()
    typealias DownloadComplete = () -> ()
    private var currBtnPressed = ""
    private var btcPrice: Double = -1
    private let currencies = ["USD", "EUR", "GBP"]
    let halfCurrencies = ["USD", "EUR", "GBP", "uBTC", "mBTC", "Satoshi", "Bitcoin"]
    let btcCurrencies = ["uBTC", "mBTC", "Satoshi", "Bitcoin"]
    let halfNums = ["USD":0, "EUR":1, "GBP":2,]
    let nums = ["USD":0, "EUR":1, "GBP":2, "uBTC":3, "mBTC":4, "Satoshi":5, "Bitcoin":6]
    let btcNums = ["uBTC":0, "mBTC":1, "Satoshi":2, "Bitcoin":3]
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
    @IBOutlet weak var calcOutput: AllowedCharsTextField!
    @IBOutlet weak var calcInput: AllowedCharsTextField!
    
    
    
    /* IBActions */
    
    
    @IBAction func pricePressed(_ sender: Any) {
        calcView.isHidden = true
        priceView.isHidden = !priceView.isHidden
        priceBTN.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        calcBTN.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
    }
    
    @IBAction func calcCurrPick1Prsd(_ sender: Any) {
        currBtnPressed = "calc1"
        if lastCurrPressed != "calc1" {
            currencyPick.reloadData()
        }
        lastCurrPressed = "calc1"
        calcView.isUserInteractionEnabled = false
        currencyPick.reloadData()
        let indexpath = IndexPath(row: nums[calcCurrencyPick1.currentTitle!]!, section: 0)
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        currView.isHidden = false
    }
    
    @IBAction func calcCurr2Prsd(_ sender: Any) {
        currBtnPressed = "calc2"
        if lastCurrPressed != "calc2" {
            currencyPick.reloadData()
        }
        lastCurrPressed = "calc2"
        calcView.isUserInteractionEnabled = false
        let indexpath = IndexPath(row: btcNums[calcCurrencyPick2.currentTitle!]!, section: 0)
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        currView.isHidden = false
    }
    
    @IBAction func priceCurrPickPrsd(_ sender: Any) {
        currBtnPressed = "price"
        if lastCurrPressed != "price" {
            currencyPick.reloadData()
        }
        lastCurrPressed = "price"
        calcView.isUserInteractionEnabled = false
        let indexpath = IndexPath(row: halfNums[currentCurr]!, section: 0)
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        currView.isHidden = false
    }
    
    @IBAction func calcPressed(_ sender: Any) {
        calcView.isHidden = false
        priceView.isHidden = true
        priceBTN.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        calcBTN.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")

    }
    
    
    /* User-defined functions */
    
    
    @IBAction func inputEdited(_ sender: Any) {
        if let i = calcInput.text {
            calcOutput.text = cnvrtTo(inputInt: Double(i)!, inputType: calcCurrencyPick1.currentTitle!, outputType: calcCurrencyPick2.currentTitle!)
        }
    }
    
    @IBAction func outputEdited(_ sender: Any) {
    }
    
    func cnvrtTo(inputInt:Double, inputType:String, outputType:String) -> String{
        if inputType == "Satoshi" {
            return String(cnvrtToLast(inputInt: inputInt/100000000, outputType: outputType))
        } else if inputType == "mBTC" {
            return String(cnvrtToLast(inputInt: inputInt/1000, outputType: outputType))
        } else if inputType == "uBTC" {
            return String(cnvrtToLast(inputInt: inputInt/1000000, outputType: outputType))
        } else {
            return String(cnvrtToLast(inputInt: inputInt, outputType: outputType))
        }
    }
    
    func cnvrtToLast(inputInt:Double, outputType:String) -> Double {
        if outputType == "Satoshi" {
            return inputInt*100000000
        } else if outputType == "uBTC" {
            return inputInt*1000000
        } else if outputType == "mBTC" {
            return inputInt*1000
        } else {
            return inputInt
        }
    }
    
    func downloadBTCdata(completion: @escaping () -> Void) {
        var url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        Alamofire.request(url).responseJSON { response in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, AnyObject> {
                    if let usd = bpi[currentCurr] as? Dictionary<String, AnyObject> {
                        self.btcPrice = usd["rate_float"]! as! Double
                    }
                }
            }
        }
        
        url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(self.pastString)&end=\(self.todayString)&currency=\(currentCurr)")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        bitcoinHistory = []
        
        Alamofire.request(url).responseJSON {response in
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, Double> {
                    for i in 0..<self.chartLength {
                        let btcAdd1:String = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -(self.chartLength-i), to: Date())!)
                        let btcAdd2 = bpi[btcAdd1]
                        self.bitcoinHistory.append(btcAdd2!)
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
        let line1 = LineChartDataSet(values: lineChartEntry, label: "")
        line1.circleRadius = CGFloat(4.0)
        line1.circleHoleRadius = CGFloat(2.0)
        line1.colors = [NSUIColor.blue]
        line1.drawCirclesEnabled = false
        let xAxis = btcChart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.labelPosition = .bothSided
        line1.drawValuesEnabled = false
        line1.drawFilledEnabled = true
        line1.highlightColor = UIColor.black
        line1.mode = (line1.mode == .cubicBezier) ? .linear : .cubicBezier
        let data = LineChartData()
        data.addDataSet(line1)
        btcChart.data = data
        btcChart.highlightValue(x: Double(chartLength), dataSetIndex: 0)
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
        if self.bitcoinHistory.count != self.chartLength || self.btcPrice == -1 {
            if !chartLoad.isAnimating {
                chartLoad.startAnimating()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.chartAsync()
            }
            btcChart.isHidden = true
        } else {
            btcPriceLabel.text = "\(symbols[currentCurr]!)\(btcPrice)"
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
        if currBtnPressed == "calc1" {
            return halfCurrencies.count
        } else if currBtnPressed == "calc2"{
            return btcCurrencies.count
        } else {
            return currencies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currBtnPressed == "price" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
            let text = currencies[indexPath.row]
            cell.textLabel?.text = text
            return cell
        } else if currBtnPressed == "calc2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
            let text = btcCurrencies[indexPath.row]
            cell.textLabel?.text = text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
            let text = halfCurrencies[indexPath.row]
            cell.textLabel?.text = text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calcView.isUserInteractionEnabled = true
        if currBtnPressed == "calc1" {
            calcCurrencyPick1.setTitle(halfCurrencies[indexPath.row], for: UIControlState.normal)
        } else if currBtnPressed == "calc2"{
            calcCurrencyPick2.setTitle(btcCurrencies[indexPath.row], for: UIControlState.normal)
        } else {
            priceCurrencyPick.setTitle(currencies[indexPath.row], for: UIControlState.normal)
            currentCurr = currencies[indexPath.row]
            btcPrice = -1
            chartAsync()
            downloadBTCdata {}
        }
        currView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        if touch?.view != currView && !currView.isHidden {
            currView.isHidden = true
            calcView.isUserInteractionEnabled = true
        }
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
        currencyPick.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        downloadBTCdata{}
        btcChart.isHidden = true
        let marker =  BalloonMarker(color: hexStringToUIColor(hex: "#111111"), font: UIFont.systemFont(ofSize: 12), textColor: hexStringToUIColor(hex: "#999999"), insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
        marker.image = UIImage(named: "dashboard-point_heart")
        marker.size = CGSize(width: 50, height: 50)
        marker.chartView = self.btcChart
        self.btcChart.marker = marker
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.chartAsync()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

