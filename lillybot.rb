require_relative './lib/twitch/chat'
require_relative './blackjack/blackjack'
require 'rufus-scheduler'
require 'json'
require 'cleverbot'

def clever_lilly(message)
        if $bot == nil
            $bot = Cleverbot.new($configs["clever_user"], $configs["clever_api_key"])
        end
        send_message $bot.say(message.downcase.sub!('lilly', ''))
end

def say_hello(user, message)
    if user != "astrious" && user != "dragnflier" && user != "catbag"
        send_message JSON.parse(File.read("configs/responses.json"))["greetings"].sample.sub!("user", "#{user}")
    else
        if user == "astrious"
            send_message "Hi Astrious, I missed you! Ready to stream again today? <3"
        else
            send_message "#{user}! How are you? I missed you!"
        end
    end
end

def be_touched(user)
    if user != "astrious" && user != "dragnflier"
        send_message ".timeout #{user} 1"
        send_message "Don't touch me there!"
    else
        send_message "*blushes*" if user == "astrious"
        send_message "That's for later, #{user} <3" if user == "dragnflier"
    end
end

def be_disgusted(user)
    send_message ".timeout #{user} 1"
    send_message "You're disgusting..."
end

def spam_bot(user, spam = true)
    if user == "astrious" || user == "dragnflier"
        if spam
            @scheduler = Rufus::Scheduler.new
            @job = @scheduler.every '10m', first_in: '0s' do
                send_message "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"
            end
        else
            send_message "I can stop now? Being a sell out is tiring work..."
            @scheduler.unschedule(@job)
        end
    end
end

def play_slots(user, message)
    file = File.read("configs/responses.json")
    responses = JSON.parse(file)
    faces = nil
    if message =~ /cat/i
        faces = responses["catslots"]
    else
        if message =~ /dog/i
            faces = responses["dogslots"]
        else
            faces = responses["slots"]
        end
    end

    face1 = faces.sample
    face2 = faces.sample
    face3 = faces.sample

    if face1 == face2 && face2 == face3
        if face1 == 'Kappa'
            send_message "Oh dear. Bad luck, #{user}!"
            send_message ".timeout #{user} 60"
        else
            if face1 =='AssFace'
                send_message "What a cutie! <3"
            else
                if face1 == 'FrankerZ' || face1 == 'LilZ'
                    send_message "I love dogs!"
            end
        end
        send_message "Congratulations!"
    end
    else
        if (face1 == face2) || (face1 == face3) || (face2 == face3)
            send_message "So close!"
        else
            send_message "Better luck next time!"
        end
    end
    send_message "You rolled: #{face1} #{face2} #{face3}"
end

def play_chance(user)
    result = rand(5) + 1
    if result == 3
        send_message "Bad luck, #{user}! You've been timed out for 20 seconds"
        send_message ".timeout #{user} 20"
    else
        send_message "What good luck you have, #{user}!"
    end
    send_message "You rolled: #{result}"
end

def guessing_game
    if @guessing_value == nil
        @guessing_value = rand(50) +1
        send_message "I've started a guessing game! Try guess the number between 1 and 50 using !guess"
    else
        send_message "A guessing game has already been started. Try guess the number between 1 and 50 using !guess"
    end
end

def make_guess(user, guess)
    if guess.to_i == @guessing_value
        send_message "Congratulations #{user}, you got it!"
        @guessing_value = nil
    else
        if guess.to_i < @guessing_value
            send_message "Higher, #{user}."
        else
            send_message "Lower, #{user}."
        end
    end
end

def print_messages(messages)
    if messages != nil
        messages.reverse.each do |message|
            send_message message.to_s.gsub("[", "").gsub("]", "")
        end
    end
end

$configs = JSON.parse(File.read("res/login.json"))

client = Twitch::Chat::Client.new(channel: $configs["channel"], nickname: $configs["nickname"], password: $configs["password"]) do
    commands = JSON.parse(File.read('configs/commands.json'))
    @guessing_value = nil
    @blackjack_game = nil

    on(:connect) do
        send_message 'Hi guys!'
    end

    on(:message) do |user, message|
        case message
            when /\Ah(i|ello|ey).*lilly/i then
                say_hello(user, message)
            when /MaiWaifu/ then
                send_message "MaiWaifu"
            when /\A!\S*touch\Z/i then
                be_touched(user)
            when /\A!\S*(anal|cock|penis|pen15|vagina|pussy)\Z/i then
                be_disgusted(user)
            when /\A!quote/i then
                send_message JSON.parse(File.read('configs/responses.json'))['quotes'].sample
            when /\A!commands/i then
                send_message "I can respond to my name and any of these commands, plus many more: #{JSON.parse(File.read('configs/commands.json')).keys.sample(5).join(", ")}"
            when /(\A!!|\S.*!!)\Z/ then
                send_message "#{message}!"
            when /\A!.*pat/i then
                send_message "*scrunches face at #{user}*"
            when /\A!.*poke/i then
                send_message "Don't do that!"
                send_message ".timeout #{user} 1"
            when /\A!.*kiss/i then
                unless user == "astrious" || user == "dragnflier"
                    send_message "I don't think Astrious appreciates that, #{user}"
                else
                    send_message "*blushes*"
                end
            when /\A!meme/i then
                send_message JSON.parse(File.read('configs/responses.json'))['meme'].sample
            when /\A!.*slots/i then
                play_slots(user, message)
            when /\A!chance/i then
                play_chance(user)
            when /\A!.*(punch|attack)/ then
                send_message "We don't accept violence here"
                send_message ".timeout #{user} 1"
            when /\A!spambot\s(on|off)\Z/i then
                if user == "astrious" || user == "dragnflier"
                    if message =~ /on/i
                        spam_bot(user)
                    else
                        spam_bot(user, false)
                    end
                end
            when /\A!spambot\Z/i then
                send_message "Should I turn off or on? I'm not sure, #{user}"
            when /\Ahappy birthday\s\w*/i then
                send_message "#{message}!"
            when /\A!guessinggame/i then
                guessing_game
            when /\A!guess\s\d+/
                make_guess(user, message.scan(/\d+/).first)
            when /\A!start21\Z/i then
                if @blackjack_game == nil
                    @blackjack_game = BlackJackGame.new
                    send_message "I've started a new game of 21. Draw a card with !hit, or !stand if you think you're too close to 21"
                else
                    send_message "There's already a blackjack game started, #{user}. Why don't you try !hit"
                end
            when /\A!hit\Z/i then
                print_messages @blackjack_game.hit(user) if @blackjack_game != nil
                send_message "There isn't a blackjack game started, #{user}." if @blackjack_game == nil
                @blackjack_game = nil if @blackjack_game != nil && @blackjack_game.is_finished
            when /\A!stand\Z/i then
                print_messages @blackjack_game.stand(user) if @blackjack_game != nil
                send_message "There isn't a blackjack game started, #{user}." if @blackjack_game == nil
                @blackjack_game = nil if @blackjack_game != nil && @blackjack_game.is_finished
            when /\A!endround\Z/i then
                print_messages @blackjack_game.finish if @blackjack_game != nil
                @blackjack_game = nil if @blackjack_game != nil
            else
                # check if message matches any keys as a regex object. Grab the first one.
                valid_key = commands.keys.select { |key| message.to_s.match(Regexp.new(key, true)) }.first
                 if valid_key
                     puts "Found it!"
                     begin
                         send_message eval(commands[valid_key])
                     rescue => ex
                         send_message commands[valid_key].gsub("user", user)
                     end

                 else
                    if message =~ /\A!.*/
                        commands[message] = "That feature has not yet been implemented."
                        File.open("configs/commands.json", "w") do |f|
                            f.write(JSON.pretty_generate(commands))
                        end
                        send_message commands[message]
                    end
                end
            end
        end
    end

client.run!
