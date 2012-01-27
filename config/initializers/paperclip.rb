# smart ID partitioning so we don't max out files in one directory
Paperclip.interpolates(:id_smart) do |attachment, style|
  limit = 33600
  if attachment.instance.id > limit
    id_partition(attachment, style)
  else
    id(attachment, style)
  end
end

# Direct paperclip logging to Rails logger, not STDOUT
#Paperclip.logger = Rails.logger
#Paperclip.options[:logger] = Rails.logger
