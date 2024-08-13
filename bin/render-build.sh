#!/usr/bin/env bash

set -o errexit

bundle install

bin/rails runner "ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS call_rail_data')"
