def find_nth_occurrence(var, substring, n)
	position = -1
	if n > 0 && var.include?(substring) # is n positive, and var includes substring
		i = 0
		while i < n do
			position = var.index(substring, position+substring.length) if position != nil
			i += 1
		end
	end
	# return the index of the nth occurrence of substring if it exists, otherwise -1
	return position != nil && position != -1 ? position + 1 : -1; 
end

css = STDIN.read

line_number = ENV['TM_LINE_NUMBER'].to_i - 1;
column = ENV['TM_LINE_INDEX'].to_i;
line = ENV['TM_CURRENT_LINE'];
scope = ENV['TM_SCOPE'];

length = css.length

real_offset = find_nth_occurrence(css, "\n", line_number) + column;

# We are doing something only if we are in valid scope
if scope.include?("property-list")
  opening_bracket = css.rindex('{', real_offset - length)
  closing_bracket = css.index('}', real_offset)
  previous_bracket = css.rindex('}', real_offset - length)
  
  
  if !(closing_bracket == nil || opening_bracket == nil)
    rule_start = ""
  
    # If we are at the beginning of file
    if previous_bracket == nil
      previous_bracket = 0
      closing_bracket += 1
      rule_start = "\n\n"
    end
  
    # Getting rule text to copy
    rule_start += css.slice(previous_bracket, real_offset - previous_bracket)
  
    # Removing @keywords
    rule_start = rule_start.gsub(/\s*@.*;\s*/, "")
  
    # Removing comments
    rule_start = rule_start.gsub(/\/\*(.|\n)*\*\//, "")
    rule_start = rule_start.gsub(/(\s*\n){2,}/, "\n\n")
  
    # Copying the rest of the rule
    rule_end = css.slice(real_offset, closing_bracket - real_offset)
    
    # Outputting all we got
    print rule_end, rule_start
  end
end