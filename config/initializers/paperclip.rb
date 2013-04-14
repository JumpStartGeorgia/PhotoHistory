require 'utf8_converter'
Paperclip.interpolates('converted_basename') do |attachment, style|
  Utf8Converter.convert_ka_to_en(File.basename(attachment.original_filename, File.extname(attachment.original_filename)))
end
