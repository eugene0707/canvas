# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  TYPES = { 'AdminProfile' => 'admin', 'RegularProfile' => 'regular' }.freeze

  enum type: TYPES
  validates_presence_of :type

  TYPES.each do |key, value|
    define_method "#{value}?" do
      type == key
    end
  end
  def type_enum
    [[AdminProfile.model_name.human, 'admin'], [RegularProfile.model_name.human, 'regular']]
  end
end
