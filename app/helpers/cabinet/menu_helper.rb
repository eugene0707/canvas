module Cabinet
  module MenuHelper
    ##
    # Create a sidebar menu element in cabinet.
    #
    # @param [Hash] options The options hash.
    # @option options [Class] :model Resource for menu link.
    # @option options [String] :action Action for menu link.
    # @option options [String] :name Menu link text
    # @option options [String] :url Link href.
    # @option options [String] :icon (false) Link icon css class.
    # @option options [String] :level (false) Level of menu nesting.
    # @param [Block] &block Nested menu block.
    def sidebar_item(options = {})
      model = options[:model] || :application
      action, name, url, icon, level = options.values_at(:action, :name, :url, :icon, :level)
      return unless policy(model).send "#{action}?"

      icon_html = icon.present? ? content_tag(:i, nil, class: %W[fa #{icon} fa-fw]) : ''

      if block_given?
        nav_level = %w[second third][level.to_i]
        arrow_html = content_tag(:span, nil, class: %w[fa arrow]).html_safe
        subitem_html = content_tag :ul, nil, class: %W[nav nav-#{nav_level}-level collapse] do
          yield(level.to_i + 1).html_safe
        end
      end

      link_html = link_to "#{icon_html}#{name}#{level}#{arrow_html}".html_safe,
                          url,
                          class: (current_page?(url) ? :active : nil)

      content_tag :li, "#{link_html.html_safe}#{subitem_html}".html_safe
    end
  end
end
