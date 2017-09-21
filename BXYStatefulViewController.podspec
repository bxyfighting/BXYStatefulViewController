Pod::Spec.new do |s|
  s.name         = 'BXYStatefulViewController'
  s.version      = '1.0.0'
  s.summary      = "Placeholder views based on content, loading, error or empty states."
  s.description  = "A view controller subclass that presents placeholder views based on content, loading, error or empty states."
  s.homepage         = 'https://github.com/bxyfighting/BXYStatefulViewController.git'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'baixiangyu' => 'bxyfighting@163.com' }
  s.ios.deployment_target = '8.0'
  s.source           = { :git => "https://github.com/bxyfighting/BXYStatefulViewController.git", :tag => s.version }
  s.requires_arc     = true
  s.source_files     = 'BXYStatefulViewController/Classes/**/*.{h,m}'
  s.public_header_files = 'BXYStatefulViewController/Classes/**/*.{h}'
  s.frameworks = 'UIKit', 'Foundation'
end
