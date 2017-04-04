platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

abstract_target 'Common' do

    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'RxSwift', '~> 2.0'
    pod 'RxCocoa', '~> 2.0'

    target 'RxSwiftDemo' do

    end

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
