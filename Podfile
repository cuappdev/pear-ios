# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Pear' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for Pear
    # User Data
    pod 'GoogleSignIn'

    # Networking
    pod 'SwiftyJSON'
    pod 'FutureNova', :git => 'https://github.com/cuappdev/ios-networking.git'


    # UI Frameworks
    pod 'IQKeyboardManagerSwift'
    pod 'Kingfisher'
    pod 'SnapKit'
    pod 'SideMenu'

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
