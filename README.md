#![Image of LillySatou](lilly.jpg)LillyBot

Welcome to Lillybot! I am a Twitch.TV bot written in Ruby. I respond to a number of commands, will participate in conversations based on various keywords and will even play games. A list of commands/interactions are available [below](#commands).

---

##Installation

1. Ensure you have [Ruby](https://www.ruby-lang.org/en/documentation/installation/) installed. You can check with `whereis ruby` or `ruby -v`
2. [Fork](https://github.com/sbaker7/lillybot/fork) the repo
3. Make a branch: `git checkout -b [new-feature-or-whatever]`
4. Install [Bundler](http://bundler.io): `gem install bundler`
4. Install dependencies using bundler: `bundle install`
5. Run using `ruby lillybot.rb`

---

##Making Changes

You're welcome to make any changes you wish. If you wish to contribute to the project, please make sure you make a pull request. If you've made your own fork as specified above, it should be as easy as:

1. Commit your changes `git commit -am 'TAG: added some feature'`
2. Push changes `git push origin branchname`
3. Make a [pull request](https://github.com/sbaker7/lillybot/compare?expand=1).

These are the tags we use for our commit messages:

- **_NEW_**​: New features ​
- **_ENHANCE_**​: Improvement to existing feature (Not purely visual, see ​_looks_​.) ​
- **_FIX_**​: Fixed a bug ​
- **_LOOKS_**​: UI Refinement (Not for functionality change, see ​_enhance_​.) ​
- **_SPEED_**​: Performance-related ​
- **_QUALITY_**​: Refactoring 
- ​**_DOC_**​: Documentation ​
- **_CONFIG_**​: Config setting changed
- **_TEST_**​: Testing related addition or enhancement

---

##Dependencies

###Software Tools
1. Ruby
2. Bundler

###Gems
3. A modified version of [Twitch-chat](https://github.com/sbaker7/twitch-chat) (stored locally in libs folder, originally by [EnotPoloskun](https://github.com/enotpoloskun/twitch-chat))
4. Activesupport
5. Eventmachine

---

##<a name="commands"></a>Commands Quicklist

Here's a quick list of example commands to get you started. You can play around with Lillybot on my [twitch channel](http://twitch.tv/dragnflier) in the chat at any time. Most commands and keywords will allow for slight variants to help promote 

###Commands

| Command | Function |
| ------- | -------- |
| !time | Returns the current time in Melbourne, Australia |
|!feels | Gives a short description of where Lilly's from |
|!banme | Bans the user for 1 second |
|!quote | Generates a random quote from Kawata Shoujo |
|!mycreator | Tells you who created the Lillybot |


###Keywords

| Command | Function |
| ------- | -------- |
| Hello/Hey/Hi Lilly | Lilly greets you |
| How are you, Lilly? | Lilly tells you how she is |
|Lily | You spelt Lilly wrong and she notices |
| Right Lilly | You ask Lilly's opinion |
|FrankerZ | Lilly loves dogs |

###Games

| Command | Function |
| ------- | -------- |
|!slots | Play slots with Lilly! |
|!chance | Play a game of chance. Don't get 3! |
|!guessinggame | Guess the number! |

###Complete List (With Todos)

A complete list of the commands available for Lillybot and upcoming commands can be found [here](https://github.com/sbaker7/lillybot/blob/development/Ruby/todolist.md)

---

##Hosting

LillyBot is currently hosted on a DigitalOcean Droplet. Setting up a droplet is very easy and a good way to host your bot. It does cost $5 a month for the smallest option (unless you are really dedicated and like to create/destroy droplets for the 0.007c per hour option) but to have your bot available at any time, it's a valueable option!

I've set up my droplet with Ubuntu 15.10 x64, 512MB memory, 1 CPU, 20GB SSD and 1000GB transfer. I also like to use [oh-my-zsh](http://ohmyz.sh) for some handy shortcuts with git. [Vim](http://www.vim.org/about.php) is also a great option for quick edits.

---

##Adding Commands

For any simple commands such as `!mycreator`, you can easily add these to the JSON file. Lillybot refers to a commands.json file for these simple commands.

The format for JSON is:

```JSON
{
    "command1" : "Response",
    "command2" : "Response 2"
}
```

For more complex commands or responses, such as those that use Regular Expressions, you will need to add those to the case statement in the Lillybot.rb file.

```ruby
case message
    when /Lilly/i && /\Ah(i|ello|ey)/i then
        say_hello(user, message)
    when /MaiWaifu/ then
        send_message "MaiWaifu"
    when /\A!\S*touch\Z/i then
        be_touched(user)
end
```




































