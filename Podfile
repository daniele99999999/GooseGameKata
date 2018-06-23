source 'https://github.com/CocoaPods/Specs.git'

platform :osx, '10.10'

def shared_pods
   pod 'SwifterSwift', '4.3.0'
end

target 'GooseGameKata' do
	project 'GooseGameKata'
        shared_pods
end

target 'GooseGameKataTest' do
    project 'GooseGameKata'
    shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
