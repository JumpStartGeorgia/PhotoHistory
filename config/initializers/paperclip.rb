Paperclip.interpolates('converted_basename') do |attachment, style|
  File.basename(attachment.original_filename, File.extname(attachment.original_filename)).to_ascii.gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')
end
