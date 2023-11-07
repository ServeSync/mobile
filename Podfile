# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PBL6' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PBL6
  pod 'Swinject'
  
  #api request
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'Moya/RxSwift'
  
  #rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  
  #realm
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'RxSwiftExt'
  
  #convert json object
  pod 'ObjectMapper', '~> 4.2.0'
  
  pod 'Kingfisher', '~> 6.3.1'
  
  #support UI
  pod 'MKProgress', '~> 1.1.0'
  pod 'MaterialComponents/Cards', '~> 124.2.0'
  pod 'Loaf'

  #check update version
  pod 'Siren', '~> 5.7.1'
  
  #appflyers
  pod 'AppsFlyerFramework'
  
  #adjust
  pod 'Adjust', '~> 4.33.3'

  #jwt
  pod 'JWTDecode'

  #scan QR
  pod 'SwiftQRScanner', :git => ‘https://github.com/vinodiOS/SwiftQRScanner’
  
  post_install do |pi|
      pi.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
          end
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
          if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
            target.build_configurations.each do |config|
                config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            end
          end
      end
  end

end
