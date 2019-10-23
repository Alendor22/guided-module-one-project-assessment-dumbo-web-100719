require 'pry'
require_relative '../config/environment'
system 'clear'
require 'rmagick'
include Magick

cli = CommandLineInterface.new
cli.login
cli.appointment_system

scope = Image.new("scope.jpg")
   scope.display
   exit


puts "hello world"
