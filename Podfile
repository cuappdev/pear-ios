# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'CoffeeChat' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for CoffeeChat
    # User Data
    pod 'GoogleSignIn'

    # UI Frameworks
    pod 'SnapKit'

    # Networking
    pod 'SwiftyJSON'
    pod 'FutureNova', :git => 'https://github.com/cuappdev/ios-networking.git'


    # UI Frameworks
    pod 'IQKeyboardManagerSwift'
    pod 'SnapKit'

    pod 'SideMenu'

  target 'CoffeeChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CoffeeChatUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

end
