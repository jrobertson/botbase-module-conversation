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

    add_phrases(a)
    
  end

  def query(sender='user01', said, mode: :voicechat, echo_node: 'node')    
    
    found = @phrases.detect {|pattern, _|  said =~ /#{pattern}/i }
    
    if found then
      
      if @bot.log then
        @bot.log.info "BotBaseModuleConversation/query:" + 
            " found %s in response to %s" % [found[0], said]
      end
    
      package, job = found.last.split

      h = said.match(/#{found.first}/i).named_captures
      r = run(package, job, h)
      
      if r.is_a? String or r.is_a? Hash then
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
  
  def run(package, job, h={})
    @rsc.send(package.to_sym).method(job.to_sym).call(h)
  end

end