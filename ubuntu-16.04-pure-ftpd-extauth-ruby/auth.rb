#!/usr/bin/env ruby

FTP_ROOT = "/home/ftpusers"

require 'logger'
logger = Logger.new("/var/log/ftpd-auth.log")

begin

  username = ENV['AUTHD_ACCOUNT']
  password = ENV['AUTHD_PASSWORD']

  logger.info("username #{username} attempting login...")

  # create user if user doesn't exist...
  if !Dir.exists?("#{FTP_ROOT}/#{username}")
    logger.info("#{username} directory not found, creating")
    `pure-pw useradd #{username} -d #{FTP_ROOT}/#{username} -u ftpuser < ./passfile`
  else
    logger.info("#{username} found")
  end

  # log user in...
  uid = `id -u #{username}`
  gid = `id -g #{username}`

  logger.info("authorizing #{username}...")

  puts "auth_ok:1"
  puts "uid:1000"
  puts "gid:1000"
  puts "dir:#{FTP_ROOT}/#{username}"
  puts "end"

  logger.close

rescue Exception, StandardError => e
  logger.error(e)
  puts "auth_ok:0"
end
