import Foundation
import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView

var chartLength = 50
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
    var btcPrices = [String:Double]()
    private let currencies = ["USD", "EUR", "GBP"]
    let halfCurrencies = ["USD", "EUR", "GBP", "uBTC", "mBTC", "Satoshi", "Bitcoin"]
    let btcCurrencies = ["uBTC", "mBTC", "Satoshi", "Bitcoin"]
    let halfNums = ["USD":0, "EUR":1, "GBP":2,]
    let nums = ["USD":0, "EUR":1, "GBP":2, "uBTC":3, "mBTC":4, "Satoshi":5, "Bitcoin":6]
    let btcNums = ["uBTC":0, "mBTC":1, "Satoshi":2, "Bitcoin":3]
    let todaysDate:NSDate = NSDate()
    let autoUpdateTime:Double = 60
    var lastEdited:String?
    
    
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
    @IBOutlet weak var d50: UIButton!
    @IBOutlet weak var y1: UIButton!
    @IBOutlet weak var d100: UIButton!
    @IBOutlet weak var d25: UIButton!
    @IBOutlet weak var d7: UIButton!
    
    
    /* IBActions */
    

    @IBAction func backBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "oofUnwind", sender: self)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func day7(_ sender: Any) {
        chartLength = 7
        updateBTCchart {}
        dayColorUpdate(day: 7)
        
    }

    @IBAction func day25(_ sender: Any) {
        chartLength = 25
        updateBTCchart {}
        dayColorUpdate(day: 25)
    }
    
    @IBAction func day50(_ sender: Any) {
        chartLength = 50
        updateBTCchart {}
        dayColorUpdate(day: 50)
    }
    
    @IBAction func day100(_ sender: Any) {
        chartLength = 100
        updateBTCchart {}
        dayColorUpdate(day: 100)
    }
    
    @IBAction func year1(_ sender: Any) {
        chartLength = 365
        updateBTCchart {}
        dayColorUpdate(day: 365)
    }
    
    @IBAction func pricePressed(_ sender: Any) {
        calcView.isHidden = true
        priceView.isHidden = false
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
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
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
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
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
        currencyPick.selectRow(at: indexpath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
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
        if let l = calcInput.text {
            if let i = Double(l) {
                calcOutput.text = cnvrtTo(inputInt: i, inputType: calcCurrencyPick1.currentTitle!, outputType:  calcCurrencyPick2.currentTitle!)
            }
            lastEdited = "Input"
        }
    }
    
    @IBAction func outputEdited(_ sender: Any) {
        if let l = calcOutput.text {
            if let i = Double(l) {
                calcInput.text = cnvrtTo(inputInt: i, inputType: calcCurrencyPick2.currentTitle!, outputType: calcCurrencyPick1.currentTitle!)
            }
            lastEdited = "Output"
        }
    }
        
    func dayColorUpdate(day:Int) {
        d7.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        d25.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        d50.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        d100.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        y1.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        if day == 7 {
            d7.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        }
        if day == 25 {
            d25.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        }
        if day == 50 {
            d50.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        }
        if day == 100 {
            d100.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        }
        if day == 365 {
            y1.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")
        }
    }
    
    func cnvrtTo(inputInt:Double, inputType:String, outputType:String) -> String {
        if inputType == "Satoshi" {
            return String(cnvrtToLast(inputInt: inputInt/100000000, outputType: outputType))
        } else if inputType == "mBTC" {
            return String(cnvrtToLast(inputInt: inputInt/1000, outputType: outputType))
        } else if inputType == "uBTC" {
            return String(cnvrtToLast(inputInt: inputInt/1000000, outputType: outputType))
        } else if inputType == "USD" {
            return String(cnvrtToLast(inputInt: (((inputInt/btcPrices["USD"]!*1000000).rounded())/1000000), outputType: outputType))
        } else if inputType == "GBP" {
            return String(cnvrtToLast(inputInt: (((inputInt/btcPrices["GBP"]!*1000000).rounded())/1000000), outputType: outputType))
        } else if inputType == "EUR" {
            return String(cnvrtToLast(inputInt: (((inputInt/btcPrices["EUR"]!*1000000).rounded())/1000000), outputType: outputType))
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
        } else if outputType == "USD" {
            return ((inputInt*btcPrices["USD"]!*1000000).rounded())/1000000
        } else if outputType == "GBP" {
            return ((inputInt*btcPrices["GBP"]!*1000000).rounded())/1000000
        } else if outputType == "EUR" {
            return ((inputInt*btcPrices["EUR"]!*1000000).rounded())/1000000
        } else {
            return inputInt
        }
    }
    
    func downloadBTCdataFirst() {
        var url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        Alamofire.request(url).responseJSON { response in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, AnyObject> {
                    if let usd = bpi["USD"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["USD"] = usd["rate_float"] as? Double
                    }
                    if let eur = bpi["EUR"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["EUR"] = eur["rate_float"]! as? Double
                    }
                    if let gbp = bpi["GBP"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["GBP"] = gbp["rate_float"]! as? Double
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
                    for i in 0..<chartLength {
                        let btcAdd1:String = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -(chartLength-i), to: Date())!)
                        let btcAdd2 = bpi[btcAdd1]
                        self.bitcoinHistory.append(btcAdd2!)
                    }
                }
            }
        }
    }
    
    func updateBTCData() {
        guard chartLoad.isAnimating else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.updateBTCData()
            }
            return
        }
        btcPrices = [:]
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        Alamofire.request(url).responseJSON { response in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, AnyObject> {
                    if let usd = bpi["USD"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["USD"] = usd["rate_float"] as? Double
                    }
                    if let eur = bpi["EUR"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["EUR"] = eur["rate_float"]! as? Double
                    }
                    if let gbp = bpi["GBP"] as? Dictionary<String, AnyObject> {
                        self.btcPrices["GBP"] = gbp["rate_float"]! as? Double
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.chartAsync()
        }
        
    }
    func updateBTCchart(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        pastString = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -chartLength, to: Date())!)
        let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(self.pastString)&end=\(self.todayString)&currency=\(currentCurr)")!
        bitcoinHistory = []
        
        Alamofire.request(url).responseJSON {response in
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let bpi = dict["bpi"] as? Dictionary<String, Double> {
                    for i in 0..<chartLength {
                        let btcAdd1:String = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -(chartLength-i), to: Date())!)
                        let btcAdd2 = bpi[btcAdd1]
                        self.bitcoinHistory.append(btcAdd2!)
                        
                    }
                }
            }
        }
        self.chartAsync()
        completion()
    }
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<bitcoinHistory.count {
            let value = ChartDataEntry(x: Double(i), y: bitcoinHistory[i])
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "")
        line1.colors = [NSUIColor.blue]
        line1.drawCirclesEnabled = false
        let xAxis = btcChart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.labelPosition = .bothSided
        line1.drawValuesEnabled = false
        line1.drawFilledEnabled = true
        line1.highlightColor = UIColor.black
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
    
    func chartAsync() {
        if self.bitcoinHistory.count != chartLength || self.btcPrices.count == 0 {
            print("Did not load with parameters: Target Length: \(chartLength). Actual length: \(self.bitcoinHistory.count). Number of stored BTC prices: \(self.btcPrices.count)")
            if !chartLoad.isAnimating {
                chartLoad.startAnimating()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.chartAsync()
            }
            btcChart.isHidden = true
        } else {
            btcPriceLabel.text = "\(symbols[currentCurr]!)\(btcPrices[currentCurr]!)"
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
        var l = false
        if currBtnPressed == "calc1" {
            calcCurrencyPick1.setTitle(halfCurrencies[indexPath.row], for: UIControl.State.normal)
            l = true
        } else if currBtnPressed == "calc2"{
            calcCurrencyPick2.setTitle(btcCurrencies[indexPath.row], for: UIControl.State.normal)
            l = true
        } else {
            priceCurrencyPick.setTitle(currencies[indexPath.row], for: UIControl.State.normal)
            currentCurr = currencies[indexPath.row]
            bitcoinHistory = []
            updateBTCchart {}
            chartAsync()
        }
        if l {
            if let i = lastEdited {
                if i == "Input" {
                    if let k = calcInput.text {
                        if let j = Double(k) {
                            calcOutput.text = cnvrtTo(inputInt: j, inputType: calcCurrencyPick1.currentTitle!, outputType:  calcCurrencyPick2.currentTitle!)
                        }
                    }
                } else {
                    if let k = calcOutput.text {
                        if let j = Double(k) {
                            calcInput.text = cnvrtTo(inputInt: j, inputType: calcCurrencyPick2.currentTitle!, outputType:  calcCurrencyPick1.currentTitle!)
                        }
                    }
                }
            }
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
        downloadBTCdataFirst()
        btcChart.isHidden = true
        let marker =  BalloonMarker(color: hexStringToUIColor(hex: "#111111"), font: UIFont.systemFont(ofSize: 12), textColor: hexStringToUIColor(hex: "#999999"), insets: UIEdgeInsets.init(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0))
        marker.image = UIImage(named: "dashboard-point_heart")
        marker.size = CGSize(width: 50, height: 50)
        marker.chartView = self.btcChart
        self.btcChart.marker = marker
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.chartAsync()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+autoUpdateTime) {
            self.updateBTCData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

