# o2r-inspecter
Inspection of compendium details as part of the o2r Web API

### WIP

Current possibilities:

`/api/v1/inspection/test`
shows that the api is online

`/api/v1/inspestion/<compendium_id>?file=filename.RData`
returns contents of an `.RData`-file. Currently only possible within the `o2r-inspecter/test/` directory with mock compendium directory `testCompendium`.
Name of file must be correct, error handling breaks. 

`@param objects`
if not specified, entire content of `.RData`-file is returned. Currently, only one object can be specified; specifying more than one breaks the `for()`-loop.
