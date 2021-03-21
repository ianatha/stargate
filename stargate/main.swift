import Foundation
import WebKit


let window = NSWindow(contentRect: NSMakeRect(0, 0, 800, 600), styleMask: [.titled, .closable, .miniaturizable], backing: .buffered, defer: false)
window.center()
window.title = "stargate"
window.makeKeyAndOrderFront(window)
class WindowDelegate: NSObject, NSWindowDelegate {
    private func windowWillClose(notification: NSNotification?) {
        NSApplication.shared.terminate(0)
    }
}
let windowDelegate = WindowDelegate()
window.delegate = windowDelegate

let application = NSApplication.shared
application.setActivationPolicy(NSApplication.ActivationPolicy.regular)

class ApplicationDelegate: NSObject, NSApplicationDelegate, WebFrameLoadDelegate, WebPolicyDelegate {
    var window: NSWindow
    var initialUrl: NSURL
    var exitCode: Int32
    
    init(window: NSWindow, application: NSApplication, initialUrl: NSURL) {
        self.window = window
        self.initialUrl = initialUrl
        self.exitCode = 127 // defaults to 127, we will set it to 0 upon reaching a stargate-result url
    }

    func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {

        let url = request.url!.absoluteString
            if (url.hasPrefix("stargate-result://")) {
                self.exitCode = 0
                print(url)
                NSApplication.shared.terminate(nil)
            } else {
                listener.use()
            }
    }
    
    func webView(_ webview: WebView!, didCommitLoadFor frame: WebFrame!)
    {
        // pass
    }

    func webView(_ webview: WebView!, didStartProvisionalLoadFor frame: WebFrame!)
    {
        // pass
    }
    
    func webView(_ webView: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedByFrame frame: WebFrame!) {
        NSLog("alert: \(String(describing: message))");
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let webView = WebView(frame: self.window.contentView!.frame)
        webView.frameLoadDelegate = self
        webView.policyDelegate = self
        self.window.contentView!.addSubview(webView)
        webView.mainFrame.load(URLRequest(url: initialUrl as URL))
    }
    
    private func applicationWillTerminate(notification: NSNotification) {
        exit(self.exitCode)
    }
}

if (CommandLine.arguments.count <= 1) {
    print("You must specify a URL on the command-line")
    exit(63)
}

if let url = NSURL(string: CommandLine.arguments[1]) {
    let applicationDelegate = ApplicationDelegate(window: window, application: application, initialUrl: url)
    application.delegate = applicationDelegate
    application.activate(ignoringOtherApps: true)
    application.run()
} else {
    print("You must specify a valid URL on the command-line")
    exit(63)
}

