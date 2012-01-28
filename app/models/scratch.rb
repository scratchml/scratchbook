class Scratch < ActiveRecord::Base
  validates_presence_of :data, :message => "is missing"
  validate :is_valid_xml

  def thumbnail_path
    num = self.id % 3 + 1
    "/assets/wheels/wheel-#{num}.gif"
  end

  def waveform_path
    "/assets/waveforms/waveform-1.jpg"
  end

  def to_hash(options = {})
    hash = self.attributes
    hash.reject! { |k,v| v.blank? }
    hash['data'] = self.data_hash && self.data_hash['sml']
    hash['data'] ||= self.data_hash && self.data_hash['SML']
    hash['data'] ||= {}
    return hash
  end

  def cached_hash
    Rails.cache.fetch("/scratches/#{self.id}/hash", :expires_in => 1.day) { self.to_hash }
  end

  def to_json(options = {})
    ActiveSupport::JSON.encode(self.to_hash(options))
  end

  def data_hash
    @hash ||= self.convert_data_to_hash.stringify_keys
  end

  def convert_data_to_hash
    return {} if self.data.blank?
    Hash.from_xml(self.data)
  rescue
    logger.error "ERROR: could not parse SML for Tag #{self.id} into a hash: #{$!}"
    return {}
  end

protected

  def is_valid_xml
    return false if self.data.blank? # FIXME should not happen

    xml = Nokogiri::XML.parse(self.data)
    if !xml.errors.blank?
      self.errors.add(:data, "is not valid XML")
      self.errors.add(:data, xml.errors.to_s)
      return false
    end
  end
end
