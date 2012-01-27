class User < ActiveRecord::Base

  # Unused devise modules: :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  # email validations are handled by devise :validatable
  # validates_presence_of :login, :message => "can't be blank"
  validates_uniqueness_of :login, :on => :create, :message => "has already been taken", :case_sensitive => false, :allow_nil => true
  validates_length_of :name, :within => 1..100, :allow_blank => true, :message => "must be present"
  validates_length_of :about, :within => 1..255, :allow_blank => true, :message => "must be present"

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_attached_file :avatar,
    :storage => :filesystem,
    :styles => {:small => "80x80#", :medium => "250x250#"},
    :url => "/avatars/:id_smart/:basename_:style.:extension",
    :path => ":rails_root/public/avatars/:id_smart/:basename_:style.:extension",
    :default_url => "/images/avatars/default-:style.png"
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/gif', 'image/x-png', 'image/png']
  validates_attachment_size :avatar, :less_than => 1.megabyte, :message => 'Your avatar must be less than 1MB in size.'
  # validates_attachment_presence :avatar

end
