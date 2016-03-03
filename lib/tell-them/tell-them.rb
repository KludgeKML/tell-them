module TellThem

  MAX_URL_DISPLAY_LENGTH = 60

  def self.reset
    TellThemStore.instance
  end

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
    return '' unless (has_data? || has_media_queries?) && ::Rails.env.development?
    return ActionController::Base.helpers.stylesheet_link_tag('tell-them') + 
      box_html.html_safe + 
      ActionController::Base.helpers.javascript_include_tag('tell-them', async: true)
  end

  private

  def self.box_html
    box = ''
    box += media_queries_style_html
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
    box += '      <button class="grid">Grid</button>'
    box += '      <button class="pin">Pin</button>'
    box += '    </div>'
    box += '    <dl class="list">'
    data.each do |k,v|
      box += "      <li><span class=\"list-header\">#{k}: </span>"
      begin
        URI::parse(v)
        box += "      <span class=\"list-value\"><a href=\"#{v}\">#{shorten(v)}</a></span>"
      rescue URI::InvalidURIError
        box += "      <span class=\"list-header\">#{v}</span>"
      end
      box += "      </li>"
    end
    box += '    </dl>'
    box += '  </div>'
    box += '  <div id="grid-overlay">'
    box += '    <div class="grid-contents">'
    box += '       <div class="grid-column"></div>'
    box += '       <div class="grid-space"></div>'
    box += '       <div class="grid-column"></div>'
    box += '    </div>'
    box += '  </div>'
    box += '</div>'
    box
  end

  def self.shorten(value)
    return value if value.length <= MAX_URL_DISPLAY_LENGTH
    value[0..MAX_URL_DISPLAY_LENGTH] + '...'
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
      style_box += "{ \n"
      style_box += "  \#tell-them-box:before { content: \"#{query_data[:initial]}\"; }\n" if query_data[:initial]
      style_box += "  \#tell-them-box .#{query_data[:name]} { display: block; }\n"
      style_box += " } \n"
    end
    style_box += "</style>"
  end

  def self.media_queries_flag_html
    return '' unless has_media_queries?
    flag_div = '<div class="media-flags">'
    media_queries.each do |query_data|
      flag_div += "<span class=\"media-flag #{query_data[:name]}\">#{query_data[:name].titleize}</span>"
    end
    flag_div += '</div>'
  end

  class TellThemStore
    include Singleton

    def initialize
      reset
    end

    def reset
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
