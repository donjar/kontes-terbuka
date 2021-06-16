# frozen_string_literal: true

module AboutUsersHelper
  def process_team_and_alumni(users)
    end_flag = true
    generated_divs = []
    users.each_with_index do |data, index|
      base_class = "about-us-person col-md-4 col-sm-6"
      inner_tags = []
      inner_tags.append(content_tag(:img, nil, src: data.image.url(:small)))
      inner_tags.append(content_tag(:h3, "#{data.name}"))
      generated_divs.append(content_tag(:div, nil, class: "#{base_class}", :data => {:name => "#{data.name}", :description => "#{data.description}"}) do
        inner_tags.map { |x| concat(x) }
      end)
      if index % 2 == 1 && index % 3 == 2
        generated_divs.append(content_tag(:div, nil, class: "clearfix visible-xs visible-sm visible-md visible-lg"))
        end_flag = false
      elsif index % 2 == 1 && index % 3 != 2
        generated_divs.append(content_tag(:div, nil, class: "clearfix visible-xs visible-sm"))
      elsif index % 2 != 1 && index % 3 == 2
        generated_divs.append(content_tag(:div, nil, class: "clearfix visible-xs visible-md visible-lg"))
      else
        generated_divs.append(content_tag(:div, nil, class: "clearfix visible-xs"))
      end
      generated_divs.append(content_tag(:div, nil, class: "about-us-description"))
    end
    if end_flag
      generated_divs.append(content_tag(:div, nil, class: "clearfix visible-xs visible-sm visible-md visible-lg"))
      generated_divs.append(content_tag(:div, nil, class: "about-us-description")) 
    end
    return generated_divs
  end
end
