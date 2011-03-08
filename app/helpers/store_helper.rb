module StoreHelper
  
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end
  
  # ZG test: usage of rails standard helper "content_tag" [2009-05-21 00:16 Thursday]
  def red_p_tag(attributes = {}, &block)
    style_content = "color: red;"
    style_content << "font-size: 12px;"
    attributes["style"] = style_content
    content_tag("p", attributes, &block)
  end
end