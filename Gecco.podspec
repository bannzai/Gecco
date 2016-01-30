Pod::Spec.new do |s|
  s.name = 'Gecco'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.homepage = 'https://github.com/yukiasai/'
  s.summary = 'Simply highlight items for your tutorial walkthrough, written in Swift'
  s.authors = { 'yukiasai' => 'yukiasai@gmail.com' }
  s.source = { :git => 'https://github.com/yukiasai/Gecco.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Classes/*.swift'
end

