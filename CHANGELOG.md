# Changelog

## Release Candidate 2
This is an extract of the most important changes. The full list of changes can be found [here](https://github.com/hpi-swt2/wimi-portal/issues?q=milestone%3A%22RC+2%22+is%3Aclosed).

### User Overview
* Introduced an overview of registered users for the administrator. [(#413)](https://github.com/hpi-swt2/wimi-portal/issues/413)

### Contracts
* Added contracts model and associated views. Contracts connect an employee (a HiWi) and a responsible user (a WiMi). It includes start and end dates as well as the salary and work hours. If a HiWi has no contract for a given month, no work days can be entered. [(#396)](https://github.com/hpi-swt2/wimi-portal/issues/396)

### Adding Users Workflow
* Allow WiMis to add HiWis to projects, without requiring HiWis to apply. [(#390)](https://github.com/hpi-swt2/wimi-portal/issues/390)
* Allow representatives / assistants to add users to research groups, without them having to apply. [(#361)](https://github.com/hpi-swt2/wimi-portal/issues/361)
* Unified user autocompletion. [(#397)](https://github.com/hpi-swt2/wimi-portal/issues/397)

### Overview of timesheets
* Introduced new overview of all timesheets at `/timesheets`. This lists all the timesheets a user has access to and shows their status (e.g. handed in, pending). [(#436)](https://github.com/hpi-swt2/wimi-portal/issues/436)
* The overview of timesheets that existed on user's profile pages has been removed. [(#447)](https://github.com/hpi-swt2/wimi-portal/issues/447)
* The list of timesheets on the detail pages of projects has been removed. [(#446)](https://github.com/hpi-swt2/wimi-portal/issues/446)

### Bug Fixes
* Projects can only be deleted if no work days were entered for them yet. This prevents a work day from losing the reference to its project. [(#448)](https://github.com/hpi-swt2/wimi-portal/issues/448)
* Fixed a bug with flash messages persisting over requests. [(#445)](https://github.com/hpi-swt2/wimi-portal/issues/445)
* Disallowed viewing timesheets of other users for users without heightened privileges. [(#428)](https://github.com/hpi-swt2/wimi-portal/issues/428)
* Fixed security issue where the API endpoint to reetrieve user data returned all information of users, including their signatures. [(#402)](https://github.com/hpi-swt2/wimi-portal/issues/402)
* Fixed bug where the entered break time on work days was not saved. [(#401)](https://github.com/hpi-swt2/wimi-portal/issues/401)
* Fixed an issue with the 'new work day' form where the requested project was not selected in the dropdown. [(#372)](https://github.com/hpi-swt2/wimi-portal/issues/372)

### UI Fixes
* Removed redundant 'new project' link on dashboard. [(#438)](https://github.com/hpi-swt2/wimi-portal/issues/438)
* Removed the research group overview from the representative's dashbaord. The overview can be reached from the navbar. [(#434)](https://github.com/hpi-swt2/wimi-portal/issues/434)
* More translations. ([#421](https://github.com/hpi-swt2/wimi-portal/issues/421), [#417](https://github.com/hpi-swt2/wimi-portal/issues/417))
* Unified form errors messages. [(#414)](https://github.com/hpi-swt2/wimi-portal/issues/414)
* Removed empty 'actions' elements on dashboard. [(#410)](https://github.com/hpi-swt2/wimi-portal/issues/410)
* Simplified project overview page. [(#375)](https://github.com/hpi-swt2/wimi-portal/issues/375)
* Removed redundant 'add working hours' link from project's detail pages. [(#395)](https://github.com/hpi-swt2/wimi-portal/issues/359)
* Simplified navbar. Directly link to an object if only a single on exists, instead of showing an overview. [(#362)](https://github.com/hpi-swt2/wimi-portal/issues/362) 