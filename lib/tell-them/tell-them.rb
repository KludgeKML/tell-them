module TellThem

  MAX_URL_DISPLAY_LENGTH = 60

  def self.reset
    TellThemStore.instance
  end

  def self.add(data)
    TellThemStore.instance.add(data)
  end

  def self.has_data?
    TellThemStore.instance.has_data?
  end

  def self.data
    TellThemStore.instance.data
  end

  def self.html
    return '' unless has_data? && ::Rails.env.development?
    box_html.html_safe
  end

  private

  def self.box_html
    box =  '<div id="tell-them-box">'
    box += '  <div class="contents">'
    box += '    <div class="controls">'
    box += '      <div class="corners">'
    box += '        <button data-target-corner="top-left"></button>'
    box += '        <button data-target-corner="top-right"></button>'
    box += '        <button data-target-corner="bottom-left"></button>'
    box += '        <button class="current" data-target-corner="bottom-right"></button>'
    box += '      </div>'
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
    box
  end

  def self.shorten(value)
    return value if value.length <= MAX_URL_DISPLAY_LENGTH
    value[0..MAX_URL_DISPLAY_LENGTH] + '...'
  end

  class TellThemStore
    include Singleton

    def initialize
      reset
    end

    def reset
      @data_store = {}
    end

    def add(data)
      data.each { |k,v| @data_store[k] = v }
    end

    def has_data?
      @data_store.any?
    end

    def data
      @data_store
    end
  end
end
