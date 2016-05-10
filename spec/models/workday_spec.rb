require 'rails_helper'

# RSpec.describe Workday, type: :model do
describe Workday do
  it 'has a valid factory' do
    expect(build(:workday)).to be_valid
  end

  it 'is valid with a dayDate, hoursWorked, notes' do
    workday = Workday.new(
      hoursWorked: 0.0,
      dayDate: Date.today,
      notes: 'Note for today'
    )
    expect(workday).to be_valid
  end

  it 'belongs to a user' do
    workday = build(:workday)
    expect(workday.user).to_not eq nil
  end

  it 'is invalid without a date' do
    workday = build(:workday, dayDate: nil)
    workday.valid?
    expect(workday.errors[:dayDate]).to include("can't be blank")
  end

  it 'is invalid without hours worked' do
    workday = build(:workday, hoursWorked: nil)
    workday.valid?
    expect(workday.errors[:hoursWorked]).to include("can't be blank")
  end

  it 'has todays local date when creating a new workday'

  it 'has a current status of false when there are no timePunches' do
    workday = build(:workday)
    expect(workday.retrieve_current_status).to eq false
  end

  it 'has a current status opposite of the previous status when new timePunch is added' do
    workday = build(:workday)
    current_status = workday.retrieve_current_status
    workday.timePunches << build(:time_punch, clockedInStatus: !current_status)
    new_current_status = workday.retrieve_current_status
    expect(new_current_status).to eq !current_status
  end
end
