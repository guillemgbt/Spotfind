# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Spotfind' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'PullUpController'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRealm'
  pod 'SwiftMessages', '~> 6.0.2'
  pod "MXParallaxHeader"

  target 'SpotfindTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SpotfindUITests' do
    # Pods for testing
  end

end
