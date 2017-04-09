# Using the botbase-module-conversation gem

    require 'botbase'
    require 'botbase-module-conversation'


    conf = "
    modules:
      Conversation:
        host: rse
        package_src: http://a0.jamesrobertson.eu/qbx/r/dandelion_a3
        default_package: nicole
        default_job: conversations
    "

    bot = BotBase.new(conf)
    bot.received 'how are you' #=> "I am fine thank you"

This module relies upon a kind of dRB service which can run Ruby Scripting File (RSF) jobs centrally. The default job called *conversations* returns an array object as follows:

<pre>
[
  ['general', ''],
  ['how are you', 'nicole how_are_you'],
  ["what's the time", 'time now'],
  ["tell me about (?&lt;subject&gt;.*)", 'nicole tell_me_about']
]
</pre>

The 1st row is the header entry and the remaining rows are the conversations. When the user asks "how are you" the conversation is found and the instruction *nicole how_are_you* is parsed. The returned values are the package name called *nicole*, followed by the job called *how_are_you*. The job simply returns the string *I am fine thank you*.

This gem is still under development.

## Resources

* botbase-module-conversation https://rubygems.org/gems/botbase-module-conversation

botbase bot conversation module
