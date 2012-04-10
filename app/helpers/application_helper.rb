module ApplicationHelper
  def cut_str str, length, tail
	u = str.unpack('U*')
	u.length > length ? u[0..length-1].pack('U*') + tail : str
  end

  def line_break str
	str.gsub("\n", "<br/>")
  end
end
