class BracketMatcherController < ApplicationController
  
  def index
    
  end
  
  def match_brackets
    @str = params[:str]
    custom_left = params[:custom_left] 
    custom_right = params[:custom_right]   

    # TODO: make this string into a model and do validation there
    
    if ((custom_left == '' and custom_right != '') or 
      (custom_right == '' and custom_left != ''))
      redirect_to('/?m=msg')

    elsif (!custom_left.empty? and !custom_right.empty?)
      @res = match(@str, [custom_left, custom_right])
    else
      @res = match(@str)
    end
  end
  


  def match(str, btypes = ['$a', '$a'])
    
    @custom_left = btypes[0]
    @custom_right = btypes[1]
    
    lcount = 0
    rcount = 0
    left_bracket_stack = []
    
    str.each_char do |c|

      if c =~ /\(|\{|\[|\<|#{Regexp.escape(@custom_left)}/ 
        lcount += 1 
        left_bracket_stack << c
      end
      
      if c =~ /\)|\}|\]|\>|#{Regexp.escape(@custom_right)}/  
        
        rcount += 1 
        return false unless left_bracket_stack[-1] == opposite_bracket(c)
        left_bracket_stack.pop
      end
             
      return false if (lcount - rcount) < 0

    end
    lcount == rcount  
  end
  
  def opposite_bracket(c)
    case c
    when ')'
      return '('
    when '}'
      return '{'
    when ']'
      return '['
    when '>'
      return '<'
    when @custom_right
      return @custom_left
    end
  end



  
  
end