# open-abap-core

Reuseable ABAP functionality

For use with latest https://github.com/abaplint/transpiler

## Contributing

- To ensure the stuff works you need to have [nodejs](https://nodejs.org/) installed
- run `npm install`
- to run linter - `npm run lint`
- to run tests - `npm run unit`
- to run all together - `npm test` (please beware that both linter and test should pass for PR to be accepted)
- to add new functionality please cover it with unit tests appropriately

For example [cl_abap_datfm.clas.abap](./src/date_time/cl_abap_datfm.clas.abap) implements the `cl_abap_datfm` class. The [cl_abap_datfm.clas.testclasses.abap](./src/date_time/cl_abap_datfm.clas.testclasses.abap) defined unit tests for it. So all like in real ABAP :)

## Add-ons

* [open-abap-gui](https://github.com/open-abap/open-abap-gui) SAP GUI related classes/functionality
* [open-abap-odata](https://github.com/open-abap/open-abap-odata)
* [open-abap-bal](https://github.com/open-abap/open-abap-bal) BAL logging
* [shims-rfc](https://github.com/open-abap/shims-rfc) Shims for tRFC + qRFC + bgRFC