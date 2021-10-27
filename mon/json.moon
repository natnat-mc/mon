local mod
(pcall -> mod = require 'cjson') unless mod
(pcall -> mod = require 'dkjson') unless mod
mod
