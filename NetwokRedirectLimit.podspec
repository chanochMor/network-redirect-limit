
Pod::Spec.new do |spec|

  spec.name = "NetwokRedirectLimit"
  spec.version = "1.0.0"
  spec.summary = "NetwokRedirectLimit alows you to maintain better your http requests"
  spec.description = "NetwokRedirectLimit alows you to maintain better your http requests by given possibilitys for limits amount of redircting the url address"
  spec.homepage = "https://github.com/chanochMor/network-redirect-limit"
  spec.license = "MIT"
  spec.author = { "Chanoch M" => "ch.mor86@gmail.com" }
  spec.platform = :ios, "13.0"
  #spec.ios.deployment_target = "5.0"
  spec.source = { :git => "https://github.com/chanochMor/network-redirect-limit", :tag => ""1.0.0""}
  spec.source_files  = "NetwokRedirectLimit/**/*.{h,m,swift}"


end
