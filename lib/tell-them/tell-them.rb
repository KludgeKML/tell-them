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

  def self.has_media_grid_info?
    TellThemStore.instance.has_media_grid_info?
  end

  def self.media_queries
    TellThemStore.instance.media_queries
  end

  def self.media_grid_max_columns
    TellThemStore.instance.media_grid_max_columns
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
    box += '</div>'
    box += media_grid_html
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
      style_box += media_grid_css(query_data)
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

  def self.media_grid_html
    return '' unless has_media_grid_info?
    grid_box =  '  <div id="grid-overlay">' + "\n"
    grid_box += '    <div class="grid-content">' + "\n"
    grid_box += "       <div class=\"grid-column #{validity_string}\"></div>" + "\n"
    (2..media_grid_max_columns).each do |c|
      grid_box += "       <div class=\"grid-space #{validity_string(c)}\"></div>" + "\n"
      grid_box += "       <div class=\"grid-column #{validity_string(c)}\"></div>" + "\n"
    end
    grid_box += '    </div>' + "\n"
    grid_box += '  </div>' + "\n"
  end

  def self.validity_string(columns = nil)
    validity_string = ""
    column_array.each { |c| validity_string += "valid-for-#{c} " if columns.nil? || c >= columns }
    validity_string
  end

  def self.column_array
    array = []
    media_queries.each { |mq| array << mq[:columns] }
    array
  end

  def self.media_grid_css(query_data)
    return '' unless has_media_grid_info?
    grid_css =  "  \#grid-overlay .grid-content .grid-column { display: none !important; }\n"
    grid_css += "  \#grid-overlay .grid-content .grid-space { display: none !important; }\n"
    grid_css += "  \#grid-overlay .grid-content { margin-top: #{query_data[:margin_top]}; }\n" if query_data.has_key?(:margin_top)

    if query_data[:columns] == 1
      grid_css += "  \#grid-overlay .grid-content { margin-left: #{query_data[:margins]} !important; margin-right: #{query_data[:margins]} !important }\n"
      grid_css += "  \#grid-overlay .grid-content .grid-column.valid-for-1 { display: inline-block; width: 100%; }\n"
    else
      units = query_data[:column_width].gsub(/[0-9]/,'')
      total_c_width = query_data[:column_width].gsub(units,'').to_i * query_data[:columns]
      total_s_width = query_data[:column_space].gsub(units,'').to_i * (query_data[:columns] - 1)
      total_width = (total_c_width + total_s_width).to_s + units
      grid_css += "  \#grid-overlay .grid-content { width: #{total_width}; }\n"
      grid_css += "  \#grid-overlay .grid-content .grid-column.valid-for-#{query_data[:columns]} { display: inline-block !important; width: #{query_data[:column_width]} }\n"
      grid_css += "  \#grid-overlay .grid-content .grid-space.valid-for-#{query_data[:columns]} { display: inline-block !important; width: #{query_data[:column_space]} }\n"
    end
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

    def has_media_grid_info?
      return false unless has_media_queries?
      @media_queries.each do |mq|
        next unless mq.has_key?(:columns)
        return true if mq[:columns] == 1 && mq.has_key?(:margins)
        return true if mq[:columns] > 1 && mq.has_key?(:column_width) && mq.has_key?(:column_space)
      end
      false
    end

    def media_queries
      @media_queries
    end

    def media_grid_max_columns
      columns = 0
      media_queries.each { |mq| columns = [columns, mq[:columns]].max }
      columns
    end
  end
end
