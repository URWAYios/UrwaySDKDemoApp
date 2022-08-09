//
//  PaymentViewController.swift
//  Urway
//
 //  Copyright (c) 2020 URWAY. All rights reserved.
 
import UIKit
import SafariServices
import WebKit
import CommonCrypto

protocol IPaymentViewController: class {
    var router: IPaymentRouter? { get set }
    func apiResult(result: paymentResult, response: [String: Any]? , error: Error?)
}

class PaymentViewController: UIViewController {
    var interactor: IPaymentInteractor?
    var router: IPaymentRouter?

    internal var initModel: UWInitializer?
    
    internal var initProto: Initializer? = nil
    
    var activityIndicator =  UIActivityIndicatorView()
    var lblActivityIndicator = UILabel()
    
    var webView: WKWebView = WKWebView()

    var newURL: String = ""

    var splitstring1 : String = ""
    var payid:String = ""
    var tranid:String = ""
    var results:String = ""
    var amount:String = ""
    var cardToken: String = ""
    var respMsg: String = ""
    var responsehash:String = ""
    var responsecode:String = ""
    var cardBrand:String=""
    var maskedPan:String=""
    var data:String = ""
    var requestHash:String = ""
    var merchantKey : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do someting...
        self.title = "URWAY"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = .white
        
        guard let model = initModel else {return}
        self.interactor?.postAPI(for: model)

        
        webView = WKWebView()
        webView.configuration.preferences.javaScriptEnabled = true

        webView.navigationDelegate = self
        activityIndicator.frame = CGRect(x: view.frame.width / 2 - 40,
                                         y: view.frame.height / 2,
                                         width: 40,
                                         height: 40)

        activityIndicator.center = view.center
        activityIndicator.color = .red
        webView.frame = view.frame
        self.view.addSubview(webView)
     //   self.view.addSubview(activityIndicator)


        activityIndicator.layer.zPosition = 1
        activityIndicator.startAnimating()
        
        lblActivityIndicator = UILabel(frame: CGRect(x: view.frame.width / 2 - 40,
        y: view.frame.height / 2,
        width: 200,
        height: 150))
        lblActivityIndicator.center = view.center
        lblActivityIndicator.textAlignment = .center
        lblActivityIndicator.textColor = .black
       // lblActivityIndicator.layer.zPosition = 1
        lblActivityIndicator.numberOfLines = 2
        lblActivityIndicator.text = "Please wait \n Transaction is in process ..."
        self.view.addSubview(lblActivityIndicator)
        
        
        webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())

       
       
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
     
    
}

extension PaymentViewController: IPaymentViewController {
    func apiResult(result: paymentResult , response: [String: Any]?  , error: Error?) {
        
        responsecode = (response?["responsecode"] as? String) ?? "nil"
        if responsecode.isEmpty || responsecode == "nil"{
            responsecode = (response?["responseCode"] as? String) ?? "nil"
        }
        
        
        if responsecode == "000" {
            print("success")
                           payid = (response?["payid"] as? String) ?? "nil"
                           tranid = (response?["tranid"] as? String) ?? ""
                           responsecode = (response?["responsecode"] as? String) ?? "nil"
                           amount = (response?["amount"] as? String) ?? ""
                           cardToken = (response?["cardToken"] as? String) ?? ""
            cardBrand=(response?["cardBrand"] as? String) ?? ""
            maskedPan=(response?["maskedPAN"] as? String) ?? ""
                           if responsecode.isEmpty || responsecode == "nil"{
                               responsecode = (response?["responseCode"] as? String) ?? "nil"
                           }
                           

                           let message = UMResponceMessage.responseDict[responsecode] ?? ""
                           
                           
                           let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: message ,tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message)
                   
                           initProto?.didPaymentResult(result: .sucess , error: nil , model: model)
                           return
                
            }else {
                print("not sucess")
            
           
            
            // targeturl  == "some value" || targeturl == ""/null
            let targetURL : String = response?["targetUrl"] as? String ?? ""
            if targetURL.count == 0 {
                payid = (response?["payid"] as? String) ?? "nil"
                tranid = (response?["tranid"] as? String) ?? ""
                responsecode = (response?["responsecode"] as? String) ?? "nil"
                amount = (response?["amount"] as? String) ?? ""
                cardBrand=(response?["cardBrand"] as? String) ?? ""
                maskedPan=(response?["maskedPAN"] as? String) ?? ""
                if responsecode.isEmpty || responsecode == "nil"{
                    responsecode = (response?["responseCode"] as? String) ?? "nil"
                }
                
                
                let message = UMResponceMessage.responseDict[responsecode] ?? ""
                print(message)
                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: "Failure",tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
                return
            }else{
                DispatchQueue.main.async {
                    self.lblActivityIndicator.removeFromSuperview()
                    guard  let url = URL(string: fullURL) else {return}
                    self.webView.load(URLRequest(url: url))
                }
            }
               
               
        }
           
    
        
    
    }
 
    // do someting...
}

extension PaymentViewController: WKNavigationDelegate {
    // do someting...
}

extension PaymentViewController {
    // do someting...
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.isLoading {
            return
        }
        estimatedProgress(keyPath: "estimatedProgress")
    }
    
    func estimatedProgress(keyPath :String) {
        
        activityIndicator.startAnimating()
        
        if keyPath == "estimatedProgress" {
            
            print("check-->" ,self.webView.url)
            let thisnewURL = self.webView.url
            
            self.newURL =  thisnewURL?.absoluteString ?? ""
            
            
            let fullNameArr = self.newURL.components(separatedBy: "&")
            print(fullNameArr)
            
            payid = fullNameArr.first?.split(separator: "?").last?.components(separatedBy: "=").last ?? "nill"
            tranid = fullNameArr.filter({$0.contains("TranId")}).first?.components(separatedBy: "=").last ?? ""
            results = fullNameArr.filter({$0.contains("Result")}).first?.components(separatedBy: "=").last ?? ""
            responsecode = fullNameArr.filter({$0.contains("ResponseCode")}).first?.components(separatedBy: "=").last ?? ""
            amount = fullNameArr.filter({$0.contains("amount")}).first?.components(separatedBy: "=").last ?? ""
            cardToken = fullNameArr.filter({$0.contains("cardToken")}).first?.components(separatedBy: "=").last ?? ""
            
            cardBrand =
                fullNameArr.filter({$0.contains("cardBrand")}).first?.components(separatedBy: "=").last ?? ""
            maskedPan =
                fullNameArr.filter({$0.contains("maskedPAN")}).first?.components(separatedBy: "=").last ?? ""
            
            if payid == "nill" || payid.isEmpty{
                self.payid = tranid
            }
            
            if responsecode.isEmpty {
                responsecode = fullNameArr.filter({$0.contains("Responsecode")}).first?.components(separatedBy: "=").last ?? ""
            }
            
            if responsecode.isEmpty {
                responsecode = fullNameArr.filter({$0.contains("responseCode")}).first?.components(separatedBy: "=").last ?? ""
            }
            
            
            if !responsecode.isEmpty || self.newURL.contains("HTMLPage.html") || self.newURL.contains("gateway"){
                self.activityIndicator.stopAnimating()
                self.lblActivityIndicator.removeFromSuperview()
            }
            
            if newURL.contains("Successful") {
                
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: message ,tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message)
                
                initProto?.didPaymentResult(result: .sucess , error: nil , model: model)
            }
            else if newURL.contains("Unsuccessful")
            {
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: "Failure",tokenID: cardToken,cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
            }
            else if newURL.contains("Failure")
            {
                
                self.activityIndicator.stopAnimating()
                 self.lblActivityIndicator.removeFromSuperview()
                
                let message = UMResponceMessage.responseDict[responsecode] ?? ""

                
                let model = PaymentResultData(paymentID: payid, transID: tranid, responseCode: responsecode, amount: amount, result: "Failure",tokenID: cardToken,
                                              cardBrand: cardBrand,maskedPan: maskedPan,responseMsg: message)
                
                initProto?.didPaymentResult(result: .failure(message), error: nil , model: model)
            }
            
            
        } else {
            
            print("Testing")
        }
        
    }
    
   
}



public class PaymentResultData {
    public var paymentID: String
    public var transID: String
    public var responseCode: String
    public var amount: String
    public var result: String
    public var tokenID: String
    public var cardBrand:String
    public var maskedPan:String
    public var respMsg:String
    
    public init(paymentID: String , transID: String , responseCode: String , amount: String , result: String , tokenID: String,cardBrand:String,maskedPan:String, responseMsg:String) {
        self.paymentID = paymentID
        self.transID = transID
        self.responseCode = responseCode
        self.amount = amount
        self.result = result
        self.tokenID = tokenID
        self.cardBrand=cardBrand
        self.maskedPan=maskedPan
        self.respMsg=responseMsg
    }
}

