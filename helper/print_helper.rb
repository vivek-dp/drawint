module DI
  module PrintHelper
    def self.time_utc len
      time_str = ""
      case len
      when 1
        time_str = "#{Time.now.strftime("%H")}"
      when 2
        time_str = "#{Time.now.strftime("%H:%M")}"
      when 3
        time_str = "#{Time.now.strftime("%H:%M:%S")}"
      when 4
        time_str = "#{Time.now.strftime("%H:%M:%S.%L")}"
      end
      return time_str
    end
  end
end #module DIPP