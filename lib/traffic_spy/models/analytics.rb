module TrafficSpy
  module Analytics
    # def self.url_sorter(payloads)
    #   url_hash = Hash.new(0)
    #   payloads.collect {|payload| payload[:url]}.each do |url|
    #    url_hash[url] += 1
    #   end
    #   url_hash.sort_by {|url, hits| hits}.reverse
    # end

    # def self.browser_sorter(payloads)
    #   browser_hash = Hash.new(0)
    #   payloads.collect {|payload| payload[:user_agent]}.each do |ua|
    #     browser_hash[UserAgent.parse(ua).browser] += 1
    #   end
    #   browser_hash.sort_by {|browser, hits| hits}.reverse
    # end

    # def self.os_sorter(payloads)
    #   os_hash = Hash.new(0)
    #   payloads.collect {|payload| payload[:user_agent]}.each do |ua|
    #     os_hash[UserAgent.parse(ua).platform] += 1
    #   end
    #   os_hash.sort_by {|os, hits| hits}.reverse
    # end

    # def self.rez_sorter(payloads)
    #   rez_hash = Hash.new(0)
    #   payloads.collect do |pl|
    #     "#{pl[:resolution_width]} x #{pl[:resolution_height]}"
    #   end.each do |rez|
    #     rez_hash[rez] += 1
    #   end
    #   rez_hash.sort_by {|rez, hits| hits}.reverse
    # end

    # def self.avg_response_times(payloads)
    #   urls = payloads.exclude(responded_in: nil).select(:url, :responded_in)
    #   counts =  urls.group_and_count(:url).inject({}) do |memo, url|
    #     memo[url[:url]] = url[:count]; memo
    #   end

    #   response_times = urls.inject(Hash.new(0)) do |memo, url|
    #     memo[url[:url]] += url[:responded_in]
    #     memo
    #   end

    #   avg = Hash.new(0)
    #   response_times.each do |url, total_time|
    #     avg[url] = total_time / counts[url]
    #   end
    #   avg.sort_by {|k,v| v}.reverse
    # end

    # def self.find_all_by_path(path)
    #   data.where(path: path)
    # end

    # def self.response_times_for_path(payloads)
    #   paths = payloads.exclude(responded_in: nil).select(:path, :responded_in).to_a

    #   paths.collect {|path| path[:responded_in]}.sort.reverse
    # end
  end
end