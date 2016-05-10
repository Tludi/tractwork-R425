require 'rails_helper'

RSpec.describe TimePunch, type: :model do
  it 'is valid with entry, clockedInStatus' do
    time_punch = TimePunch.new(
      entry: Time.now,
      clockedInStatus: true
    )
    expect(time_punch).to be_valid
  end

  it 'is invalid when entry is nil' do
    time_punch = build(:time_punch, entry: nil)
    time_punch.valid?
    expect(time_punch.errors[:entry]).to include("can't be blank")
  end
end
