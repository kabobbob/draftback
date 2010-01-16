# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # toggle table row background
  def alt( s='', s2='2')
    "class='alt#{ cycle( s, s2 ) }'"
  end
  
  # obscures email for display
  def obscure_email(email)
    return nil if email.nil? #Don't bother if the parameter is nil.
    
    lower = ('a'..'z').to_a
    upper = ('A'..'Z').to_a
    email.split('').map { |char|
      output = lower.index(char) + 97 if lower.include?(char)
      output = upper.index(char) + 65 if upper.include?(char) 
      output ? "&##{output};" : (char == '@' ? '&#0064;' : char)
    }.join
  end
  
  # obtain ordinal numbers
  def number_to_ordinal(num)
    num = num.to_i
    if (10...20)===num
      "#{num}th"
    else
      g = %w{ th st nd rd th th th th th th }
      a = num.to_s
      c=a[-1..-1].to_i
      a + g[c]
    end
  end
  
  def show_notify_bar(text, delay = 2500, speed = 'normal')
    unless text.empty?
      javascript_tag "showNotifyBar('#{text}', 'notify_div', #{delay}, '#{speed}');"
    end
  end
end
