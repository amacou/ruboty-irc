require "zircon"

module Ruboty
  module Adapters
    class Irc < Base
      include Mem

      env :IRC_SERVER, "IRC server name"
      env :IRC_PORT, "IRC port" ,optional: true
      env :IRC_USERNAME, " IRC user name (e.g. ruboty)", optional: true 
      env :IRC_PASSWORD, "Account's password (e.g. xxx)" ,optional: true
      env :IRC_CHANNEL, "Channel name ruboty first logs in (e.g. #test)"
     
      def run
        bind
        client.run!
      rescue Interrupt
        exit
      end

      def say(message)
        message[:body].split("\n").each do | MSG | 
          client.notice(channel, msg)
        end 
      end

      private

      def client
        @client ||= Zircon.new(
          server: server,
          port: port,
          channel: channel,
          username: username,
        )
      end

      private
      def server
        ENV["IRC_SERVER"]
      end

      def port
        ENV["IRC_PORT"] || 6667
      end

      def channel
        ENV["IRC_CHANNEL"]
      end

      def password
        ENV["IRC_PASSWORD"]
      end

      def username
        ENV["IRC_USERNAME"] || "ruboty"
      end

      def bind
        client.on_privmsg(&method(:on_message))
      end

      def on_message(message)
        robot.receive(
          body: message.body,
          from: message.from,
          to: message.to,
          type: message.type,
        )
      end
    end
  end
end
