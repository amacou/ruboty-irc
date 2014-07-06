require "zircon"

module Ruboty
  module Adapters
    class Irc < Base
      include Mem

      env :IRC_SERVER_NAME, "Account's JID (e.g. 12345_67890@chat.IRC.com)"
      env :IRC_NICKNAME, "Account's nickname, which must match the name on the IRC account (e.g. ruboty)"
      #env :IRC_PASSWORD, "Account's password (e.g. xxx)"
      env :IRC_CHANNEL, "Room name ruboty first logs in (e.g. 12345_room_a,12345_room_b)"

      def run
        bind
        client.run!
      rescue Interrupt
        exit
      end

      def say(message)
        client.notice("notice")
        client.privmsg("privmsg")




        #client.say(
        #  body: message[:code] ? "/quote #{message[:body]}" : message[:body],
        #  from: message[:from],
        #  to: message[:original][:type] == "chat" ? message[:to] + "/resource" : message[:to],
        #  type: message[:original][:type],
        #)
      end

      private

      def client
        @client ||= Zircon.new(
          server: server,
          port: 6667,
          channel: channel,
          username: nickname,
        )
      end

      private
      def server
        ENV["IRC_SERVER_NAME"]
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
        client.on_message(&method(:on_message))
      end

      def connect
        client.connect
      end

      def on_message(message)
        robot.receive(
          body: message.body,
          from: message.from,
          #from_name: username_of(message),
          to: message.to,
          type: message.type,
        )
      end

      def on_invite(message)
        client.join(message.from)
      end

      def username_of(message)
        case message.type
        when "groupchat"
          Xrc::Jid.new(message.from).resource
        else
          client.users[message.from].name
        end
      end
    end
  end
end
