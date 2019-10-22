require 'pry'
require_relative '../config/environment'
system 'clear'

cli = CommandLineInterface.new
cli.login
cli.appointment_system


puts "hello world"
