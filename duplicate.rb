def find_nth_occurrence(var, substring, n)
  position = -substring.length;
  n.times do
    if position != nil
      position = var.index(substring, position + substring.length)
    end
  end
  position
end

line_number = Integer(ENV['TM_LINE_NUMBER']) - 1;
column = Integer(ENV['TM_LINE_INDEX']) + 1;
scope = ENV['TM_SCOPE'];

# We are doing something only if we are in valid scope
if scope.include?('property-list')
  
  css = STDIN.read
  real_offset = find_nth_occurrence(css, "\n", line_number) + column;
  
  closing_bracket = css.index('}', real_offset)
  previous_bracket = css.rindex('}', real_offset - css.length)
  
  if !(closing_bracket == nil)
    rule_start = ''
  
    # If we are at the beginning of file
    if previous_bracket == nil
      previous_bracket = 0
      closing_bracket += 1
      rule_start = "\n\n"
    end
  
    # Getting rule text to copy
    rule_start += css.slice(previous_bracket, real_offset - previous_bracket)
  
    # Removing @keywords
    rule_start.gsub!(/\s*@.*;\s*/, '')
  
    # Removing comments
    rule_start.gsub!(/\/\*(.|\n)*\*\//, '')
    rule_start.gsub!(/(\s*\n){2,}/, "\n\n")
  
    # Copying the rest of the rule
    rule_end = css.slice(real_offset, closing_bracket - real_offset)
    
    # Outputting all we got
    print rule_end, rule_start
  end
end