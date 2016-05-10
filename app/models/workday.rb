# workday.rb
class Workday < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :timePunches

  accepts_nested_attributes_for :timePunches
  validates_presence_of :dayDate, :hoursWorked

  def retrieve_last_time_punch
    timePunches.last
  end

  def retrieve_current_status
    current_time_punch = retrieve_last_time_punch
    if current_time_punch.nil?
      false
    else
      current_time_punch.clockedInStatus
    end
  end

  def self.calculate_workhours(workday)
    # get current workday punches and push times to array
    @punches = []
    workday_punches = workday.timePunches
    workday_punches.each do |p|
      @punches << p.created_at
    end

    # group punches in pairs then push to array
    punch_groups = []
    @punches.in_groups_of(2, Time.current) do |group| # Time.current is used when punch count is odd
      punch_groups << group
    end

    # Iterate through groups of punch pairs to get time difference
    # and add each groups difference for a total hours worked
    @work_hours = 0
    punch_groups.each do |pg|
      # @workHours += TimeDifference.between(pg[0], pg[1]).in_hours
      @work_hours += pg[1] - pg[0]
    end
    # convert the fractional of hours worked from hour percentage to minutes
    # workHourModulus = @workHours.modulo(1)*0.6.round(2)
    # workHourWholeNumber = @workHours.round(0)
    # workdayHours = workHourWholeNumber + workHourModulus
    workday.hoursWorked = @work_hours
    workday.save
    @work_hours
  end

  def self.retrieve_current_workday(user)
    # wd = user.workdays.last
    user_workdays = user.workdays.all
    unless user_workdays.nil?
      user_workdays.each do |wd|
        if wd.dayDate == Date.current
          @current_workday = wd
          break
        else
          @current_workday = nil
        end
      end
    end

    if @current_workday
      @current_workday
    else
      current_project = user.account.projects.first
      Workday.create(user_id: user.id, project_id: current_project.id, dayDate: Date.current, hoursWorked: 0)
    end
  end
end
