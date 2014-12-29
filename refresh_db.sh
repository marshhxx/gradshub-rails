#!/bin/bash

rake db:drop
rake dv:create
rake db:migrate
rake db:seed

