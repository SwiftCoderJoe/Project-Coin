import UIKit
import Charts
import NVActivityIndicatorView

class btcVC: UIViewController {
    let bitcoinHistory: [Double] = [8000, 8200, 8500, 8700, 9200, 9237]
    
    @IBOutlet weak var btcChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
