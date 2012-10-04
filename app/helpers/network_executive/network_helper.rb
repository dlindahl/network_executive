module NetworkExecutive
  module NetworkHelper

    def network_name
      NetworkExecutive.config.name
    end

    def guide_header_width
      '%.3f' % (1 / (@guide.times.size.to_f + 1) * 100)
    end

  end
end