# frozen_string_literal: true

require 'fileutils'

module Rails
  module DevLograge
    class << self
      FILE = 'tmp/lograge-dev.txt'

      def enable_by_file
        FileUtils.mkdir_p('tmp')

        if File.exist?(FILE)
          delete_cache_file
          puts 'Development mode is no longer using lograge.' # rubocop:disable Rails/Output
        else
          create_cache_file
          puts 'Development mode is now using lograge.' # rubocop:disable Rails/Output
        end

        FileUtils.touch 'tmp/restart.txt'
      end

      def enable_by_argument(lograge)
        FileUtils.mkdir_p('tmp')

        if lograge
          create_cache_file
        elsif lograge == false && File.exist?(FILE)
          delete_cache_file
        end
      end

      private

      def create_cache_file
        FileUtils.touch FILE
      end

      def delete_cache_file
        File.delete FILE
      end
    end
  end
end
