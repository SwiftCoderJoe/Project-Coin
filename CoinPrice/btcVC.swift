import UIKit
import Charts
import NVActivityIndicatorView

class btcVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* Variable declaration */
    
    
    let bitcoinHistory: [Double] = [8000, 8200, 8500, 8700, 9200, 9237]
    private let currencies = ["USD", "EUR", "JPY"]
    
    
    /* IBOutlets */
    
    
    @IBOutlet weak var currencyPick: UITableView!
    @IBOutlet weak var priceView: UIView!
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
    
    @IBAction func calcPressed(_ sender: Any) {
        calcView.isHidden = false
        priceView.isHidden = true
        priceBTN.backgroundColor = hexStringToUIColor(hex: "#1D76AB")
        calcBTN.backgroundColor = hexStringToUIColor(hex: "#2CB0FF")

    }
    
    
    /* User-defined functions */
    
    
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<bitcoinHistory.count {
            let value = ChartDataEntry(x: -Double(i), y: bitcoinHistory[i])
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
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPick.dataSource = self
        currencyPick.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        updateGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
