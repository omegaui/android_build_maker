import Cocoa
import FlutterMacOS
import bitsdojo_window_macos
class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
     return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    flutterViewController.backgroundColor = .clear
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    // Access the NSWindow and set it to non-resizable
    if let nsWindow = self.window {
        nsWindow.styleMask.remove(.resizable)
    }
    super.awakeFromNib()
  }
}
