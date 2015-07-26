module TellThem
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

  class TellThemStore
    include Singleton

    def initialize
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
