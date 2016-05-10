class TimePunch < ActiveRecord::Base
  belongs_to :workday

  validates_presence_of :entry
  validates_inclusion_of :clockedInStatus, in: [true, false]

  def invertStatus
    !currentStatus
  end

end
