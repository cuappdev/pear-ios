# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Pear' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for Pear
    # User Data
    pod 'GoogleSignIn', '5.0.2'
    pod 'GooglePlaces', '4.2.0'

    # Networking
    pod 'SwiftyJSON'
    pod 'Alamofire'

    # Feedback
    pod 'AppDevAnnouncements', :git => 'https://github.com/cuappdev/appdev-announcements.git', :commit => '8e4a569087e7ee16caf4eaaf1c9ff9926783ae9a'
    pod 'CHIPageControl/Jaloro'

    # UI Frameworks
    pod 'IQKeyboardManagerSwift'
    pod 'Kingfisher'
    pod 'SnapKit'
    pod 'SideMenu'

    # Messaging
    pod 'Firebase/Messaging'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'

  target 'PearTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PearUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

end
