
. ./helper_library.sh

start_time_epoch="${1?The start of the period of time is necessary -epoch time}"
end_time_epoch="${2?The end of the period of time is necessary -epoch time}"

# Convert the period of time to the format of date-time the Neew Relic Explorer
# API accepts
start_time=$( get_NewRelic_date_from_epoch "${start_time_epoch}" )
if [[ $? -ne 0 ]]; then
     echo "Aborting"
     exit 1
fi
end_time=$( get_NewRelic_date_from_epoch "${end_time_epoch}" )
if [[ $? -ne 0 ]]; then
     echo "Aborting"
     exit 2
fi

# Get the APPID you need from the names of your application in New Relic
#
# curl -X GET 'https://api.newrelic.com/v2/applications.json'  -H "X-Api-Key:${API_KEY}" \
#      -d 'filter[ids]=<your-pattern>'  | json_fmt


# More variables are possible in the for-loop below

for possible_variable in average_response_time average_network_time average_fe_response_time average_dom_content_load_time total_app_time call_count average_queue_time
do
    echo "Querying the samples taken in New Relic for the variable" \
         "${possible_variable} for ${APPID} between time ${start_time} and" \
         "${end_time} ..."

    curl --silent -X GET \
         "https://api.newrelic.com/v2/applications/${APPID}/metrics/data.json" \
         --header "X-Api-Key:${API_KEY}" \
         --data "names[]=EndUser&values[]=${possible_variable}&from=${start_time}&to=${end_time}" | \
    json_fmt

done

