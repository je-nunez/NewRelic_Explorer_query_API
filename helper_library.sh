#!/usr/bin/env bash


# function get_NewRelic_date_from_epoch

function get_NewRelic_date_from_epoch {

    local epoch_in=${1?Epoch time is necessary as first argument}

    date +"%FT%T%:z" -d @${epoch_in}
    local err_exit=$?
    
    [[ "$err_exit" -ne 0 ]] && echo "Error in parameter epoch datetime: ${epoch_in}" >&2 

    return $err_exit
}


# function get_http_body
# gets only the HTTP response body, discarding the HTTP response header

function get_http_body {

    # strip off the HTTP response headers from standard-input

    sed '1,/^'$'\r''$/d'
}


# function json_fmt
# formats the JSON it reads from standard-input

function json_fmt {

    python -m json.tool

}

# function _check_environment_vars
# checks if some required environment variables are set before
# running the exported functions in this library. Also the
# initialization code of this library warns if any of the
# required environment variables are not set.

function _check_environment_vars {

     if [ -z ${API_KEY} ]; then
        echo "Variable API_KEY is unset. Please set it with the New Relic " \
         "Explorer API Key -not the New Relic License Key ()." \
         "( https://docs.newrelic.com/docs/apis/rest-api-v2/requirements/api-key#viewing )" >&2
        return 1
     fi

     if [ -z ${APPID+x} ]; then
        echo "Variable APPID is unset. Please set it with the New Relic " \
             "Application ID of the application you want to query." >&2
        return 2
     fi

     return 0

}


#
# Initialization code of the library
#

# warn if the necessary environment variables are not yet set

_check_environment_vars

