Pod::Spec.new do |s|
    s.name = 'SNNetworkClient'
    s.version = '1.0.0'
    s.license = 'MIT'
    s.summary = 'A simple network client for sending POST and GET request with Decodable response.'
    s.homepage = 'https://github.com/eitguide/SNNetworkClient/'
    s.authors = { 'Nghia Nguyen' => 'nghiaklpro195@gmail.com' }
    s.source = { :git => 'https://github.com/eitguide/SNNetworkClient.git', :tag => s.version }
    s.documentation_url = 'https://github.com/eitguide/SNNetworkClient/'
  
    s.ios.deployment_target = '10.0'

    s.dependency 'Alamofire', '~> 5.0'
    s.dependency 'RxSwift', '~> 6.0'
    s.dependency 'RxCocoa', '~> 6.0'

    s.swift_version    = '5.0'
  
    s.source_files = 'Sources/*.swift'
end

  