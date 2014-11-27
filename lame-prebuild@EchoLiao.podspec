Pod::Spec.new do |s|
  s.name                = "lame-prebuild@EchoLiao"
  s.version             = "3.99.5.1"
  s.summary             = "lame static libraries compiled for iOS"
  s.homepage            = "http://lame.sourceforge.net/"
  s.author              = { "Echo Liao" => "echoliao8@gmail.com" }
  s.requires_arc        = false
  s.platform            = :ios
  s.source              = { :http => "https://github.com/EchoLiao/lame-prebuild/raw/master/lame-iOS-3.99.5.1.tgz" }
  s.preserve_paths      = "include/**/*.h"
  s.vendored_libraries  = 'lib/*.a'
  s.libraries           = 'mp3lame'
  s.xcconfig            = { 'HEADER_SEARCH_PATHS' => "\"${PODS_ROOT}/#{s.name}/include\"" }
end
