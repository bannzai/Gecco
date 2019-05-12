Pod::Spec.new do |s|
  s.name = 'GeccoGreenRoad'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.homepage = 'https://github.com/alexvaiman/'
  s.summary = 'Simply highlight items for your tutorial walkthrough, written in Swift'
  s.authors = { 'Alex' => 'Alex.vaiman@greenroad.com' }
  s.source = { :git => 'https://github.com/alexvaiman/Gecco.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Classes/*.swift'
end

