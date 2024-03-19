# frozen_string_literal: true

require 'tmpdir'

module Anchor
  # PEMBundle is a collection of PEM encoded certificates. It can be written
  # to a temporarly file on disk as a bundle if needed.
  #
  # This temp file to disk is needed for some other libraries that require a
  # path to a pem file, and not a string of pem encoded certificates.
  #
  class PemBundle
    DEFAULT_BASENAME = 'bundle.pem'

    def initialize(pems: [])
      @pems = pems || []
      @path = nil
      @temp_dir = nil
      @basename = DEFAULT_BASENAME
    end

    def pems
      @pems.dup
    end

    def path
      write
      @path
    end

    def with_path
      yield(path)
    ensure
      remove_path
    end

    def add_cert(cert)
      @pems << cert
      remove_path
    end

    def to_s
      @pems.join("\n")
    end

    def clear
      @pems.clear
      remove_path
    end

    private

    def temp_path
      @temp_dir = Dir.mktmpdir
      File.join(@temp_dir, @basename)
    end

    def ensure_path
      return @path if @path

      @path = temp_path
    end

    def write
      remove_path
      ensure_path
      File.open(@path, 'w+', 0o400) do |io|
        io.write(to_s)
      end
    end

    def remove_path
      File.unlink(@path) if @path && File.exist?(@path)

      if @temp_dir && Dir.exist?(@temp_dir)
        FileUtils.remove_entry_secure(@temp_dir)
        @temp_dir = nil
      end
    end
  end
end
