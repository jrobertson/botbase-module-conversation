#!/usr/bin/env ruby

# file: botbase-module-conversation.rb

# A service module used by the BotBase gem


require 'rsc'
require 'rexle-builder'


class BotBaseModuleConversation
  
  def initialize(host: nil, package_src: nil, 
                 default_package: nil, default_job: nil)    


    @rsc = RSC.new host, package_src

    a = run(default_package, default_job)
    
    header = a.shift
    
    a2 = a.inject([]) do |r, x|
      r << {conversation: {user: x[0], bot: x[-1]}}
    end

    a3 = RexleBuilder.new({converstions: a2}).to_a
    doc = Rexle.new(a3[3])
    doc.root.attributes['id'] = header.first

    @phrases = doc.root.xpath('//conversation').map do |e|
      %w(user bot).map {|x| e.text x}
    end
    
  end

  def query(sender='user01', said)
    
    found = @phrases.detect {|pattern, _|  said =~ /#{pattern}/i }

    if found then
    
      package, job = found.last.split
      h = said.match(/#{found.first}/).named_captures
      r = run(package, job)
    else  
      # do or say nothing
      ''
    end
    
  end
  
  private
  
  def run(package, job, args=[])
    @rsc.send(package.to_sym).method(job.to_sym).call(*args)
  end

end
