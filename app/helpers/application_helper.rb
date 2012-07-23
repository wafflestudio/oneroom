module ApplicationHelper
  def cut_str str, length, tail
    u = str.unpack('U*')
    u.length > length ? u[0..length-1].pack('U*') + tail : str
  end

  def line_break str
    str.gsub("\n", "<br/>")
  end

  #pagination
  def search_url url
    url.gsub!("rooms/search?", "search/")
    hash_url(url)
  end

  def hash_url url
    if url[0] == "/"
      url.gsub!(/^\//, "/#")
    end
    url
  end


  #=== Images Methods ===#
  def imgs obj
    Image.find(obj.image_ids)
  end

  def img obj
    if obj.image_ids.size > 0
      Image.find(obj.image_ids[0])
    else
      Image.first
    end
  end

end
