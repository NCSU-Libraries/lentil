module Lentil
  module ApplicationHelper
    def application_name
      Lentil::Engine::APP_CONFIG["application_name"] || 'My #HuntLibrary'
    end

    def division_name
      Lentil::Engine::APP_CONFIG["division_name"] || 'Division Name'
    end

    def division_url
      Lentil::Engine::APP_CONFIG["division_url"] || 'Division URL'
    end

    def organization_name
      Lentil::Engine::APP_CONFIG["organization_name"] || 'Organization Name'
    end

    def contact_email
      Lentil::Engine::APP_CONFIG["contact_email"] || 'admin@example.com'
    end

    def feed_description
      Lentil::Engine::APP_CONFIG["feed_description"] || 'Description of this feed'
    end

    def title(page_title = nil)
      page_title ||= ''
      page_title << ' - ' unless page_title.empty?
      page_title << application_name unless application_name.empty?
      page_title << " - #{division_name}" unless division_name.empty?
      page_title << " - #{organization_name}" unless organization_name.empty?

      content_for :title, page_title
    end

    def body_class
      "#{params[:controller].parameterize}_#{params[:action]}"
    end

    def nav_link(link_text, link_path)
      class_name = current_page?(link_path) ? 'active' : nil

      content_tag(:li, :class => class_name) do
        link_to link_text, link_path
      end
    end

    def meta_description_tag
      tag('meta', :name => 'description', :content => Lentil::Engine::APP_CONFIG["meta_description"] || '')
    end

    def google_analytics_tracker
      Lentil::Engine::APP_CONFIG["google_analytics_tracker"]
    end

  end
end
