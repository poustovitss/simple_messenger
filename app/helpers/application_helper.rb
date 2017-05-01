module ApplicationHelper
  def time_format(time)
    l time, format: :date_with_time if time
  end
end
