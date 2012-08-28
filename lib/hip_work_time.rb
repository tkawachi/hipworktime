require 'date'
require 'hipchat-api'
require 'active_support/time'

module HipWorkTime
  CONFIG = {
      start_keyword: 'in',
      end_keyword: 'out',
      timezone: 'JST',
      date_break_hour: 6, # 24時を越えて仕事をすることがありそうなので、一日の区切りをこの時間にする。
  }
end

require_relative 'hip_work_time/cached_api_access'
require_relative 'hip_work_time/message'
require_relative 'hip_work_time/time_range'
require_relative 'hip_work_time/work_time'
