import Foundation
import WebKit


let window = NSWindow(contentRect: NSMakeRect(0, 0, 800, 600), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: .Buffered, defer: false)
window.center()
window.title = "stargate"
window.makeKeyAndOrderFront(window)
class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(notification: NSNotification?) {
        NSApplication.sharedApplication().terminate(0)
    }
}
let windowDelegate = WindowDelegate()
window.delegate = windowDelegate

let application = NSApplication.sharedApplication()
application.setActivationPolicy(NSApplicationActivationPolicy.Regular)
class ApplicationDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow
    var initialUrl: NSURL
    var exitCode: Int32
    
    init(window: NSWindow, application: NSApplication, initialUrl: NSURL) {
        self.window = window
        self.initialUrl = initialUrl
        self.exitCode = 127 // defaults to 127, we will set it to 0 upon reaching a stargate-result url
    }
    
    override func webView(webView: WebView!,
        decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!,
        request: NSURLRequest!,
        frame: WebFrame!,
        decisionListener listener: WebPolicyDecisionListener!) {
            
            let url = request.URL.absoluteString!
            if (url.hasPrefix("stargate-result://")) {
                self.exitCode = 0
                println(url)
                NSApplication.sharedApplication().terminate(nil)
            } else {
                listener.use()
            }
    }
    
    override func webView(sender: WebView!, didCommitLoadForFrame frame: WebFrame!)
    {
        // pass
    }
    
    override func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!)
    {
        // pass
    }
    
    override func webView(sender: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedByFrame frame: WebFrame!) {
        NSLog("alert: \(message)");
    }
    
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!)
    {
        // pass
    }
    
    override func webView(sender: WebView!, didClearWindowObject window: WebScriptObject!, forFrame:WebFrame!) {
        // pass
    }
    
    
    func applicationDidFinishLaunching(notification: NSNotification?) {
        let webView = WebView(frame: self.window.contentView.frame)
        webView.frameLoadDelegate = self
        webView.policyDelegate = self
        self.window.contentView.addSubview(webView)
        webView.mainFrame.loadRequest(NSURLRequest(URL: initialUrl))
    }
    
    func applicationWillTerminate(notification: NSNotification) {
        exit(self.exitCode)
    }
}

if (Process.arguments.count <= 1) {
    println("You must specify a URL on the command-line")
    exit(63)
}

if let url = NSURL(string: Process.arguments[1]) {
    let applicationDelegate = ApplicationDelegate(window: window, application: application, initialUrl: url)
    application.delegate = applicationDelegate
    application.activateIgnoringOtherApps(true)
    application.run()
} else {
    println("You must specify a valid URL on the command-line")
    exit(63)
}

