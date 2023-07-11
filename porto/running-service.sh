#!/usr/bin/bash
php-fpm --nodaemonize
nginx -g "daemon off;"
