require 'cinch'

module Alice

  module Handlers

    class Treasure

      include Cinch::Plugin

      match /^\!(.+)$/, method: :find_treasure, use_prefix: false
      match /^\!(.+) (.+)/, method: :treasure, use_prefix: false
      match /^\!forge (.+)/, method: :create_treasure, use_prefix: false
      
      def forge(m, what)
        return unless m.oper
        return if treasure = Alice::Treasure.where(name: what.downcase).last
        return unless user = Alice::User.like(m.user.nick)
        Alice::Treasure.create(name: what.downcase, user: user)
        m.action_reply("forges a #{what} in the fires of Mount Doom.")
      end

      def treasure(m, what, who)
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        message = treasure.transfer_from(m.user.nick).to(who).message
        m.reply(message)
      end

      def find_treasure(m)
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        return unless treasure.user
        m.reply("#{treasure.owner} has had the #{treasure.name} for #{treasure.elapsed_time}.")
      end

    end

  end

end