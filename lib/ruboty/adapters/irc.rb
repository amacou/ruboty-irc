require "zircon"

module Ruboty
  module Adapters
    class Irc < Base
      include Mem

      env :IRC_SERVER, ""
      env :IRC_PORT, "" ,optional: true
      env :IRC_NICKNAME, "Account's nickname, which must match the name on the IRC account (e.g. ruboty)"
      env :IRC_PASSWORD, "Account's password (e.g. xxx)" ,optional: true
      env :IRC_CHANNEL, "Channel name ruboty first logs in (e.g. #test)"

      def run
        bind
        client.run!
      rescue Interrupt
        exit
      end

      def say(message)
        client.notice(channel, message[:body])
      end

      private

      def client
        @client ||= Zircon.new(
          server: server,
          port: port || 6667,
          channel: channel,
          username: nickname || :ruboty,
        )
      end

      private
      def server
        ENV["IRC_SERVER"]
      end

      def port
        ENV["IRC_PORT"]
      end

      def channel
        ENV["IRC_CHANNEL"]
      end

      def password
        ENV["IRC_PASSWORD"]
      end

      def nickname
        ENV["IRC_NICKNAME"]
      end

      def bind
        client.on_privmsg(&method(:on_message))
      end

      def connect
        client.connect
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
