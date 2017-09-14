#
#  Be sure to run `pod spec lint MappingAce.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MappingAce"
  s.version      = "1.0.4"
  s.summary      = "MappingAce is Tool about JSON <-> Model"


  s.description  = "MappingAce allows rapid creation of struct , Swift class, OC class . Automatic transform dictionary to model(model could be struct), forget to manually write property mapping code"

  s.homepage     = "https://github.com/Binglin/MappingAce"

  s.license      = "MIT"

  s.author             = { "Binglin" => "269042025@qq.com" }

  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Binglin/MappingAce.git", :tag => "#{s.version}" }
  s.source_files  = "MappingAce/*.swift"


  #s.requires_arc = true

end
