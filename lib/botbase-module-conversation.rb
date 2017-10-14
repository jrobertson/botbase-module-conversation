#!/usr/bin/env ruby

# file: botbase-module-conversation.rb

# A service module used by the BotBase gem


require 'rsc'
require 'rexle-builder'


class BotBaseModuleConversation
  
  def initialize(host: nil, package_src: nil, 
              default_package: nil, default_job: nil, callback: nil)    

    @bot = callback
    @rsc = RSC.new host, package_src
    
    a = run(default_package, default_job)
    
    @doc = Rexle.new("<conversations/>")
    #puts 'adding phrases : ' + a.inspect
    add_phrases(a)

    
  end

  def query(sender='user01', said, mode: :voicechat, echo_node: 'node')
    
    #puts 'said: ' + said.inspect
    
    found = @phrases.detect {|pattern, _|  said =~ /#{pattern}/i }
    
    if found then
      
      notice 'botbase/debug: module-conversation queried, found ' + found[0]
      #puts 'found: ' +found.inspect
    
      package, job = found.last.split

      h = said.match(/#{found.first}/i).named_captures
      r = run(package, job, h)
      
      if r.is_a? String then
        r
      elsif r.is_a? Array then
        add_phrases(r)
      end
      
    else  
      no_match_found()
    end
    
  end
  
  protected
  
  def no_match_found()
    # do or say nothing
    ''    
  end
  
  private
  
  def add_phrases(a)

    header = a.shift
    id, answer = header
    
    @doc.root.delete "conversations[@id='#{id}']"
    
    a2 = a.inject([]) do |r, x|
      r << {conversation: {user: x[0], bot: x[-1]}}
    end

    a3 = RexleBuilder.new({converstions: a2}).to_a
    doc = Rexle.new(a3[3])
    doc.root.attributes['id'] = id
    @doc.root.add_element doc.root

    @phrases = @doc.root.xpath('//conversation').map do |e|
      %w(user bot).map {|x| e.text x}
    end    
    
    answer
  end
  
  def notice(msg)
    @bot.debug msg if @bot
  end
  
  def run(package, job, h={})
    puts 'package: ' + package.inspect
    puts 'h:'  + h.inspect
    @rsc.send(package.to_sym).method(job.to_sym).call(h)
  end

end