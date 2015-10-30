platform :ios, '7.0'
inhibit_all_warnings!

xcodeproj 'PraisePop'

plugin 'cocoapods-keys', {
    :project => "PraisePop",
    :keys => [
        "ParseAppID",
        "ParseClientKey",
	"InstaBugToken"
    ]
}

pod 'AFNetworking', '~> 2.6'
pod 'SWRevealViewController', '~> 2.3'
pod 'SSKeychain', '~> 1.2'
pod 'SVWebViewController', '~> 1.0'
pod 'Mantle', '~> 2.0'
pod 'Parse', '~> 1.9'
pod 'DateTools'
pod 'UIActionSheet+Blocks'
pod 'VTAcknowledgementsViewController'
pod 'Fabric'
pod 'Crashlytics'
pod 'Instabug', '~> 4.1'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'PraisePop/Pods-Acknowledgements.plist', :remove_destination => true)
end
