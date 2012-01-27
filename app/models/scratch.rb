class Scratch < ActiveRecord::Base
  validates_presence_of :data, :message => "is missing"
  validate :is_valid_xml

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
