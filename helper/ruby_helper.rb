module DI
  module RubyHelper
    #Taken from https://stackoverflow.com/questions/8379596/how-do-i-convert-a-ruby-hash-so-that-all-of-its-keys-are-symbols
    #Change when we need later.....
    def self.symbolize_keys_deep!(h)
      h.keys.each do |k|
        ks    = k.to_sym
        h[ks] = h.delete k
        symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
      end
    end
  end
end