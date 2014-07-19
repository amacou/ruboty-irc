require "zircon"

module Ruboty
  module Adapters
    class Irc < Base
      include Mem

      env :IRC_SERVER, "IRC server name"
      env :IRC_PORT, "IRC port" ,optional: true
      env :IRC_USE_SSL, "IRC use ssl (default: false)" ,optional: true
      env :IRC_USERNAME, " IRC user name (e.g. ruboty)", optional: true
      env :IRC_NICKNAME, " IRC nick name (e.g. ruboty)", optional: true
      env :IRC_REALNAME, " IRC real name (e.g. ruboty)", optional: true
      env :IRC_PASSWORD, "Account's password (e.g. xxx)" ,optional: true
      env :IRC_CHANNEL, "Channel name ruboty first logs in (e.g. #test)"

      def run
        bind
        client.run!
      rescue Interrupt
        exit
      end

      def say(message)
        message[:type] ||= :notice
        message[:body].split("\n").each do | msg |
          client.send(message[:type].to_sym, channel, ":#{msg}")
        end
      end

      private

      def client
        @client ||= Zircon.new(
          server: server,
          port: port,
          use_ssl: use_ssl,
          channel: channel,
          username: username,
          nickname: nickname,
          realname: realname,
          password: password
        )
      end

      private
      def server
        ENV["IRC_SERVER"]
      end

      def port
        ENV["IRC_PORT"] || 6667
      end

      def use_ssl
        ENV["IRC_USE_SSL"] || false
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

      def nickname
        ENV["IRC_NICKNAME"] || "ruboty"
      end

      def realname
        ENV["IRC_REALNAME"] || "ruboty"
      end

      def bind
        client.on_privmsg(&method(:on_message))
      end

      def on_message(message)
        robot.receive(
          body: message.body.force_encoding('utf-8'),
          from: message.from,
          to: message.to,
          type: message.type,
        )
      end
    end
  end
end
