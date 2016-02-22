module ApplicationHelper
  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => CustomizeLinkRenderer
    end
    super *[collection_or_options, options].compact
  end
end


class CustomizeLinkRenderer < WillPaginate::ActionView::LinkRenderer
  protected
     def page_number(page)
       unless page == current_page
         tag(:li, link(page, page, rel: rel_value(page)), class: "waves-effect")
       else
         tag(:li, link(page, page, rel: rel_value(page)), class: "active")
       end
     end

     def previous_page
       num = @collection.current_page > 1 && @collection.current_page - 1
       previous_icon = tag(:i, "chevron_left", class: "material-icons")
       previous_or_next_page(num, previous_icon, 'previous_page')
     end

     def next_page
       num = @collection.current_page < total_pages && @collection.current_page + 1
       next_icon = tag(:i, "chevron_right", class: "material-icons")
       previous_or_next_page(num, next_icon, 'next_page')
     end

     def previous_or_next_page(page, text, classname)
       if page
         tag(:li, link(text, page, class: classname), class: "waves-effect")
       else
         tag(:li, link(text, page, class: classname), class: "disabled")
       end
     end
end
