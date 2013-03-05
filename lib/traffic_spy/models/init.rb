require 'sinatra'
require 'sinatra/base'
require 'sequel'
require 'sqlite3'
require 'json'
require 'useragent'
require './lib/traffic_spy/models/client'
require './lib/traffic_spy/models/payload'
require './lib/traffic_spy/models/event'
require './lib/traffic_spy/models/campaign'
require './lib/traffic_spy/models/campaign_event'