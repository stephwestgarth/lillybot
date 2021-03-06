require 'rufus-scheduler'
require_relative '../../lib/twitch/chat'

Lilly.plugin.define 'Spambot' do

  on(:system_start) do
    @scheduler = Rufus::Scheduler.new
    @job = nil
  end

  on(:system_stop) do
    # do nothing?
  end

  def turn_on(client)
    message = "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"

    @job = @scheduler.every '10m', first_in: '0s' do
      client.send_twitch_message message
      puts message
    end

    #message
  end

    def turn_off()
      @scheduler.unschedule(@job)
      message = "I can stop now? Being a sell out is tiring work..."
    end

    on(:spambot) do |user, message, client|
        responses = []
      if message =~ /on/i
        if user == "astrious" || user == "dragnflier"
          responses << turn_on(client)
        else
          responses << "You don't have permission to do that, #{user}"
        end
      elsif message =~ /off/i
        if user == "astrious" || user == "dragnflier"
          responses << turn_off()
        else
          responses << "You don't have permission to do that, #{user}"
        end
      else
        responses << "I don't know what '#{message}' means, #{user}"
      end
      responses
    end

  end
