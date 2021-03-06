class Object

  # fast error raise
  def r data
    data = data.to_a if data.is_a?(Enumerator)
    #raise data.class.to_s
    if data.is_a?(Hash) || data.is_a?(Array)
      data = JSON.pretty_generate(data)
      # data = data.gsub(' ', '&nbsp;').gsub($/, '<br />')
      raise data
    else
      raise "#{data.class} -> #{data.ai(plain:true)}".gsub('<', '&lt;')
    end
  end

  def rr data
    ap ['--- START', data, '--- END']
  end

end

