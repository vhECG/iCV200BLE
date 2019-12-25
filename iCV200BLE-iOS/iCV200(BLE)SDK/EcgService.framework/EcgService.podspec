Pod::Spec.new do |s|
s.name              = 'EcgService'
s.version           = '0.1.2'
s.summary           = 'Ecg data parser / interpreter'
s.homepage          = 'http://www.vhecg.com/'

s.author            = { 'Name' => 'feedback@vhecg.com' }
s.license           = { :type => 'Apache-2.0', :file => 'LICENSE' }

s.platform          = :ios
s.source            = { :http => 'https://bitbucket.org/willyang7/test/raw/533773be1b2e9bca70f989a42f6c2e7a688b37c0/EcgService.zip' }

s.ios.deployment_target = '10.0'
s.ios.vendored_frameworks = 'EcgService.framework'
end
