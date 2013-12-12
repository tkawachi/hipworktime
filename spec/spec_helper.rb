require 'coveralls'
Coveralls.wear!

$: << File.join(File.dirname(__FILE__), "../lib")

require 'hip_work_time'
include HipWorkTime
