module TellThem
  def self.add(data)
    TellThemStore.instance.add(data)
  end

  def self.enable_media_queries(data)
    TellThemStore.instance.enable_media_queries(data)
  end


  def self.has_data?
    TellThemStore.instance.has_data?
  end

  def self.data
    TellThemStore.instance.data
  end

  def self.has_media_queries?
    TellThemStore.instance.has_media_queries?
  end

  def self.media_queries
    TellThemStore.instance.media_queries
  end

  def self.html
    return '' unless has_data? && ::Rails.env.development?
    box_html.html_safe
  end

  private

  def self.box_html
    box = media_queries_style_html
    box +=  '<div id="tell-them-box">'
    box += '  <div class="contents">'
    box += '    <div class="controls">'
    box += '      <div class="corners">'
    box += '        <button data-target-corner="top-left"></button>'
    box += '        <button data-target-corner="top-right"></button>'
    box += '        <button data-target-corner="bottom-left"></button>'
    box += '        <button class="current" data-target-corner="bottom-right"></button>'
    box += '      </div>'
    box += media_queries_flag_html
    box += '      <button class="pin">Pin</button>'
    box += '    </div>'
    box += '    <dl class="items">'
    data.each do |k,v|
      box += "      <dt>#{k}</dt>"
      begin
        URI::parse(v)
        box += "      <dd><a href=\"#{v}\">#{v}</a></dd>"
      rescue URI::InvalidURIError
        box += "      <dd>#{v}</dd>"
      end
    end
    box += '    </dl>'
    box += '  </div>'
    box += '</div>'
    box
  end

  def self.media_queries_style_html
    return '' unless has_media_queries?
    style_box = "<style>"
    style_box += '#tell-them-box .media-flag { display: none; }' + "\n"

    media_queries.each do |query_data|
      style_box += '@media '
      style_box += "(min-width: #{query_data[:min]}) " if query_data[:min]
      style_box += ' and ' if query_data[:min] && query_data[:max]
      style_box += "(max-width: #{query_data[:max]}) " if query_data[:max]
      style_box += "{ \#tell-them-box .#{query_data[:name]} { display: block; } } \n"
    end
    style_box += "</style>"
  end

  def self.media_queries_flag_html
    return '' unless has_media_queries?
    flag_div = "<ul>"
    media_queries.each do |query_data|
      flag_div += "<span class=\"media-flag #{query_data[:name]}\">#{query_data[:name]}</span>"
    end
    flag_div += "</ul>"
  end

  class TellThemStore
    include Singleton

    def initialize
      @data_store = {}
      @media_queries = []
    end

    def add(data)
      data.each { |k,v| @data_store[k] = v }
    end

    def enable_media_queries(data)
      @media_queries = data
    end

    def has_data?
      @data_store.any?
    end

    def data
      @data_store
    end

    def has_media_queries?
      @media_queries.any?
    end

    def media_queries
      @media_queries
    end
  end
end
