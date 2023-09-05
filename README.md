# gainsight-px-data-loader

Utility script to update Gainsight PX user, account and custom event data using the Gainsight PX REST API.

## Install
Depends on python (>= v3.x) being installed locally and being present in the path

Also depends on the "requests" python module, (see here for more details: http://docs.python-requests.org/en/master/) install it with the following command:
```
sudo pip3 install requests
if pip is missing, install it with: sudo /usr/bin/easy_install pip
```
Depends on pytz module, install with the following command:
```
sudo pip3 install pytz
```

Depends on dateutils module, install with the following command:
```
sudo pip3 install python-dateutil
```

There is an install script that will perform the above steps on OSX/Mac:
bash ./install.sh

## Usage:
gainsight-px-data-loader [--insertMissing] [--strict] [--verbose] [--dryRun] config.json [USER|ACCOUNT|CUSTOM_EVENT] input.csv

* Data type (second argument) should either be USER, ACCOUNT or CUSTOM_EVENT
* If insertMissing is specfied, will insert missing records.  Default behavior is to update records that are found
* insertMissing does not apply to custom events, events are always inserted
* If verbose is specified, each operation is logged to stdout
* If dryRun is specified, no data is changed, inputs are parsed 
* If strict is specified, the loader verifies all data before the load and will abort on any conversion error


## CSV File Example:
```
id,title,telephone,city,state,latitude,longitude,strtmp1,acceptDate
fred@acme.com,Prez,867-5309,"Hanalei","HI",123,321,cork,2011-11-04T00:05:23
mr.speed@example.com,PFC,555-1234,"Beaufort","NC",456,654,ferrule,2020-11-04T13:05:23
```

## CSV details:
* Date values are specified as ISO 8601 strings, either "YYYY-MM-DD" or "YYYY-MM-DDTHH:mm:ss"
* If dates are specified as epoch milliseconds, they are set to the UTC timezone
* If dates are specified as ISO 8601 values, they use the timezone value from the config file, or UTC if not specified.
* String values can optionally be surrounded with double quotes to escape commas
  
## Config File Example:
```json
{
  "apiKey" : "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "productKey" : "AP-XXXXXXXXXXXX-2",
  "timezone" : "America/Los_Angeles",
  "dataCenter" : "US",
  "fieldMapping" : {
    "USER" : {
      "identifyId" : "id",
      "title" : "title",
      "phone" : "telephone",
      "location.city" : "city",
      "location.stateCode" : "state",
      "location.coordinates.latitude" : "latitude",
      "location.coordinates.longitude" : "longitude",
      "customAttributes.strtmp1" : "strtmp1",
      "customAttributes.acceptDate" : "acceptDate"
    },
    "ACCOUNT" : {
      "id" : "id",
      "name" : "account_name"
    },
    "CUSTOM_EVENT" :{
      "identifyId" : "Identify Id",
      "accountId" : "Account ID",
      "eventName" : "Event Name",
      "date" : "Date",
      "attributes.source" : "Source"
    }
  }
}
```

### Field Mapping details:
* apiKey: From the Gainsight PX Settings/REST API/New API Key screen
* productKey: From the Gainsight PX Settings/Products screen (if you need to set more than one product key on a user or account, pass as an array: ['key1','key2'])
* timezone: Optional setting, use if date or time values in file are in a timezone other than UTC. Valid values: https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568
* fieldMapping: 
    * Specifies which Gainsight PX fields will be used as targets for the data in the input file.  
    * The first field name (the key of the fieldMapping map) is the Gainsight PX name, the second (the value) is the name in the CSV input file.
    * The unique identifier field is required for both users, custom events (identifyId) and account (id)
    * To specify nested fields, use periods as separators (see location and customAttributes examples above)
    * Custom events: eventName and attributes correspond to the name and attributes usually passed in the Javascript API


