Gem::Specification.new do |s|
  s.name = 'botbase-module-conversation'
  s.version = '0.1.4'
  s.summary = 'A botbase module intended for holding a conversation ' + 
      'between the user and the bot. Relies upon a dRB service for ' + 
      'responding to the user\'s statements. Used by the botbase gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/botbase-module-conversation.rb']
  s.add_runtime_dependency('rsc', '~> 0.2', '>=0.2.2')
  s.add_runtime_dependency('rexle-builder', '~> 0.3', '>=0.3.7')
  s.signing_key = '../privatekeys/botbase-module-conversation.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/botbase-module-conversation'
end
