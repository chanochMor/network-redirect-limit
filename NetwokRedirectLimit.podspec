
Pod::Spec.new do |s|

  s.name = "NetwokRedirectLimit"
  s.version = "1.0.0"
  s.summary = "NetwokRedirectLimit alows you to maintain better your http requests"
  s.description = "NetwokRedirectLimit alows you to maintain better your http requests by given possibilitys for limits amount of redircting the url address"
  s.homepage = "https://github.com/chanochMor/network-redirect-limit"
  s.license = "MIT"
  s.author = { "Chanoch M" => "ch.mor86@gmail.com" }
  s.platform = :ios
  s.ios.deployment_target = "10.0"
  s.source = { :git => "https://github.com/chanochMor/network-redirect-limit.git", :tag => s.version}
  s.source_files = "Source/NetwokRedirectLimit/**/*.swift"
  s.swift_version = "5.0"
  
end
