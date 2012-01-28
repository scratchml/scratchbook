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
