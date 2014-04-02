# fobject
[![Build Status](https://travis-ci.org/slang800/fobject.svg?branch=master)](https://travis-ci.org/slang800/fobject)

A simple promise-based wrapper for file operations that treats files as objects.

```coffee
File = require 'fobject'
configFile = new File('./config.json')
configFile.read().done(
	(data) ->
		console.log "contents of #{configFile.path}: #{data}"
	(error) ->
		console.log "something went wrong: #{error}"
)
```
