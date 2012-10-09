# $Id: credentialstorage.rb 7 2010-03-04 16:54:09Z tdaoki $

require 'batchwalker/context'
require 'batchwalker/exception'
require 'teradata'

module BatchWalker

  class CredentialFormatError < Error; end
  class UserKeyError < Error; end

  class CredentialStorage

    DEFAULT_FILENAME = '.bwpasswd'

    def CredentialStorage.load_default(bwhome = Context.bwhome)
      raise ArgumentError, "no BWHOME" unless bwhome
      load("#{bwhome}/#{DEFAULT_FILENAME}")
    end

    def CredentialStorage.load(path)
      creds = {}
      File.foreach(path) do |line|
        next if line.strip.empty?
        key, enc, *junk = line.split
        unless junk.empty?
          raise CredentialFormatError, "corrupted credential storage"
        end
        creds[key] = LogonString.parse(decode(enc))
      end
      new(creds)
    end

    def CredentialStorage.decode(str)
      decode_v1(str)
    end

    def CredentialStorage.decode_v1(encoded)
      unless encoded.size % 2 == 0
        raise CredentialFormatError, "corrupted value: #{encoded.inspect}"
      end
      seed = encoded[0, 2].hex
      encoded[2..-1].scan(/../).map {|enc| rrotate(enc.hex, seed).chr }.join('')
    end

    BYTE_MAX = 255

    def CredentialStorage.lrotate(b, width)
      b >= width ? b - width : BYTE_MAX + 1 + b - width
    end

    def CredentialStorage.rrotate(b, width)
      n = b + width
      n > BYTE_MAX ? n - (BYTE_MAX + 1) : n
    end

    def initialize(creds)
      @creds = creds
    end

    def [](key)
      @creds[key] or raise UserKeyError, "unknown user key: #{key.inspect}"
    end

  end

end
