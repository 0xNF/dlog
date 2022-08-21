# TODO
## Mandatory goals
- [ ] Implement the Layout Parser (dont forget variables, recursive layouts)
- [ ] implement `Write` for each layoutRenderer
	- [ ] implement `Render` for each LayoutToken=>LayoutRenderer
- [ ] implement FileTarget's archival and rotation semantics
- [ ] implement JsonTarget

## Stretch goals
- [ ] implement programatic construction of loggers and log configurations
- [ ] implement runtime reload => trickle down to each logger and layout to reparse its settings

# Targets
Implemented
--
* n/a

Not Yet Implemented
--
* n/a

Will Not Implememt
--
* 

# Layouts

Implemented
--
* n/a

Not Yet Implememted
--
* [JSON](https://github.com/NLog/NLog/wiki/JsonLayout)
* [Simple](https://github.com/NLog/NLog/wiki/SimpleLayout)
* [CSV](https://github.com/NLog/NLog/wiki/CSVLayout)

Will Not Implement
--
* [Gelf](https://github.com/farzadpanahi/NLog.GelfLayout)
* [Xml](https://github.com/NLog/NLog/wiki/XmlLayout)
* [MicrosoftConsoleJsonLayout](https://github.com/NLog/NLog/wiki/MicrosoftConsoleJsonLayout)
* [MicrosoftConsoleLayout](https://github.com/NLog/NLog/wiki/MicrosoftConsoleLayout)

Undecided
--
* [Compound](https://github.com/NLog/NLog/wiki/CompoundLayout)
* [W3CExtendedLogLayout](https://github.com/NLog/NLog/wiki/W3CExtendedLogLayout)
* [Log4JXML](https://github.com/NLog/NLog/wiki/Log4JXmlEventLayout)
* [JsonArray](https://github.com/NLog/NLog/wiki/JsonArrayLayout)


# Layout Renderers

Implemented
--
* [${level}](https://github.com/NLog/NLog/wiki/level-layout-renderer)
* [${literal}](https://github.com/NLog/NLog/wiki/literal-layout-renderer)
* [${newline}](https://github.com/NLog/NLog/wiki/newline-layout-renderer)
* [${loggername}](https://github.com/NLog/NLog/wiki/loggername-layout-renderer)
* [${guid}](https://github.com/NLog/NLog/wiki/guid-layout-renderer)
* [${sequenceid}](https://github.com/NLog/NLog/wiki/sequenceid-layout-renderer)
* [${dir-separator}](https://github.com/NLog/NLog/wiki/dir-separator-layout-renderer)
* [${longdate}](https://github.com/NLog/NLog/wiki/longdate-layout-renderer)
* [${shortdate}](https://github.com/NLog/NLog/wiki/shortdate-layout-renderer)
* [${time}](https://github.com/NLog/NLog/wiki/time-layout-renderer)
* [${hostname}](https://github.com/NLog/NLog/wiki/hostname-layout-renderer)
* [${all-event-properties}](https://github.com/NLog/NLog/wiki/all-event-properties-layout-renderer)
* [${event-property}](https://github.com/NLog/NLog/wiki/event-property-layout-renderer)
* [${message}](https://github.com/NLog/NLog/wiki/message-layout-renderer)




Not Yet Implemented
--
* [${var}](https://github.com/NLog/NLog/wiki/var-layout-renderer)
* [${callsite}](https://github.com/NLog/NLog/wiki/callsite-layout-renderer)
* [${callsite-filename}](https://github.com/NLog/NLog/wiki/callsite-filename-layout-renderer)
* [${callsite-linenumber}](https://github.com/NLog/NLog/wiki/callsite-linenumber-layout-renderer)
* [${stacktrace}](https://github.com/NLog/NLog/wiki/stacktrace-layout-renderer)
* [${exception}](https://github.com/NLog/NLog/wiki/exception-layout-renderer)
* [${counter}](https://github.com/NLog/NLog/wiki/counter-layout-renderer)
* [${date}](https://github.com/NLog/NLog/wiki/date-layout-renderer)
* [${environment}](https://github.com/NLog/NLog/wiki/environment-layout-renderer)
* [${environment-user}](https://github.com/NLog/NLog/wiki/environment-user-layout-renderer)
* [${assebly-version}](https://github.com/NLog/NLog/wiki/assebly-version-layout-renderer)
* [${local-ip}](https://github.com/NLog/NLog/wiki/local-ip-layout-renderer)


Undecided
--
* [${when}](https://github.com/NLog/NLog/wiki/when-layout-renderer)
* [${whenempty}](https://github.com/NLog/NLog/wiki/whenempty-layout-renderer)
* [${onexception}](https://github.com/NLog/NLog/wiki/onexception-layout-renderer)
* [${onhasproperties}](https://github.com/NLog/NLog/wiki/onhasproperties-layout-renderer)
* [${basedir}](https://github.com/NLog/NLog/wiki/basedir-layout-renderer)
* [${currentdir}](https://github.com/NLog/NLog/wiki/currentdir-layout-renderer)
* [${file-contents}](https://github.com/NLog/NLog/wiki/file-contents-layout-renderer)
* [${log4jxmlevent}](https://github.com/NLog/NLog/wiki/log4jxmlevent-layout-renderer)
* [${procesid}](https://github.com/NLog/NLog/wiki/procesid-layout-renderer)
* [${processinfo}](https://github.com/NLog/NLog/wiki/processinfo-layout-renderer)
* [${processname}](https://github.com/NLog/NLog/wiki/processname-layout-renderer)
* [${processlifetime}](https://github.com/NLog/NLog/wiki/processlifetime-layout-renderer)



WIll Not Implement
--
* [${cached}](https://github.com/NLog/NLog/wiki/cached-layout-renderer)
* [${db-null}](https://github.com/NLog/NLog/wiki/db-null-layout-renderer)
* [${object-path}](https://github.com/NLog/NLog/wiki/object-path-layout-renderer)
* [${exceptiondata}](https://github.com/NLog/NLog/wiki/exceptiondata-layout-renderer)
* [${activity}](https://github.com/NLog/NLog/wiki/activity-layout-renderer)
* [${activityid}](https://github.com/NLog/NLog/wiki/activityid-layout-renderer)
* [${gdc}](https://github.com/NLog/NLog/wiki/gdc-layout-renderer)
* [${install-context}](https://github.com/NLog/NLog/wiki/install-context-layout-renderer)
* [${mdc}](https://github.com/NLog/NLog/wiki/mdc-layout-renderer)
* [${mdlc}](https://github.com/NLog/NLog/wiki/mdlc-layout-renderer)
* [${ndc}](https://github.com/NLog/NLog/wiki/ndc-layout-renderer)
* [${ndlc}](https://github.com/NLog/NLog/wiki/ndlc-layout-renderer)
* [${scopenested}](https://github.com/NLog/NLog/wiki/scopenested-layout-renderer)
* [${scopeproperty}](https://github.com/NLog/NLog/wiki/scopeproperty-layout-renderer)
* [${scopetiming}](https://github.com/NLog/NLog/wiki/scopetiming-layout-renderer)
* [${ticks}](https://github.com/NLog/NLog/wiki/ticks-layout-renderer)
* [${json-encode}](https://github.com/NLog/NLog/wiki/json-encode-layout-renderer)
* [${left}](https://github.com/NLog/NLog/wiki/left-layout-renderer)
* [${lowercase}](https://github.com/NLog/NLog/wiki/lowercase-layout-renderer)
* [${norawvalue}](https://github.com/NLog/NLog/wiki/norawvalue-layout-renderer)
* [${pad}](https://github.com/NLog/NLog/wiki/pad-layout-renderer)
* [${replace}](https://github.com/NLog/NLog/wiki/replace-layout-renderer)
* [${replace-newlines}](https://github.com/NLog/NLog/wiki/replace-newlines-layout-renderer)
* [${right}](https://github.com/NLog/NLog/wiki/right-layout-renderer)
* [${rot13}](https://github.com/NLog/NLog/wiki/rot13-layout-renderer)
* [${substring}](https://github.com/NLog/NLog/wiki/substring-layout-renderer)
* [${trim-whitespace}](https://github.com/NLog/NLog/wiki/trim-whitespace-layout-renderer)
* [${uppercase}](https://github.com/NLog/NLog/wiki/uppercase-layout-renderer)
* [${url-encode}](https://github.com/NLog/NLog/wiki/url-encode-layout-renderer)
* [${wrapline}](https://github.com/NLog/NLog/wiki/wrapline-layout-renderer)
* [${xml-encode}](https://github.com/NLog/NLog/wiki/xml-encode-layout-renderer)
* [${appsettings}](https://github.com/NLog/NLog/wiki/appsettings-layout-renderer)
* [${configetting}](https://github.com/NLog/NLog/wiki/configetting-layout-renderer)
* [${registry}](https://github.com/NLog/NLog/wiki/registry-layout-renderer)
* [${filesystem-normalize}](https://github.com/NLog/NLog/wiki/filesystem-normalize-layout-renderer)
* [${nlogdir}](https://github.com/NLog/NLog/wiki/nlogdir-layout-renderer)
* [${processdir}](https://github.com/NLog/NLog/wiki/processdir-layout-renderer)
* [${specialfolder}](https://github.com/NLog/NLog/wiki/specialfolder-layout-renderer)
* [${tempdir}](https://github.com/NLog/NLog/wiki/tempdir-layout-renderer)
* [${identity}](https://github.com/NLog/NLog/wiki/identity-layout-renderer)
* [${windows-identity}](https://github.com/NLog/NLog/wiki/windows-identity-layout-renderer)
* [${gelf}](https://github.com/farzadpanahi/NLog.GelfLayout)
* [${appdomain}](https://github.com/NLog/NLog/wiki/appdomain-layout-renderer)
* [${gc}](https://github.com/NLog/NLog/wiki/gc-layout-renderer)
* [${machinename}](https://github.com/NLog/NLog/wiki/machinename-layout-renderer)
* [${performancecounter}](https://github.com/NLog/NLog/wiki/performancecounter-layout-renderer)
* [${threadid}](https://github.com/NLog/NLog/wiki/threadid-layout-renderer)
* [${threadname}](https://github.com/NLog/NLog/wiki/threadname-layout-renderer)
* [${aspnet-*}](https://github.com/NLog/NLog/wiki/aspnet-*-layout-renderer)

Non-standard to be implemented
--
* ${unixtime}



## Architecture

This project is based entirely off NLog, and takes major inspiriation from its architecture.  Although simplified, much of the underlying systems are laid out in the same manner.

```mermaid
flowchart TD
	z{Rule\nwhat and where} --> t
	t{Target\ntype,name} --> Layout
	Layout --> x{{List LayoutRenderer}}
	Layout --> y{{List Rule}}
```


## Differences from NLog
### layouts
* Strings must be surrounded by single-quotes  
	- e.g., `${literal:text=hello}` -> `${literal:text='hello'}`
* ASP.NET integrations will not be considered
* Config file is json based, not xml based. Xml parsing will not be consideed at this time
* Some layout renderers that are not in NLog are included here. See also: [${unixtime}](#non-standard-to-be-implemented)
* `${event-property}` layout renderer uses `JSONPath` syntax for nested objects in the `objectpath` property
* requred properties must be in `key=value` form.
	- e.g., `${event-property:item1}` is not permitted. Use `${event-property:item=item1}` instead