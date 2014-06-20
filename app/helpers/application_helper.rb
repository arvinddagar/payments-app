module ApplicationHelper
  def as_html_data(hash)
    data = {}
    hash.each do |k,v|
      data["data-#{k.to_s.gsub("_","-")}"] = v
    end
    data
  end
end
