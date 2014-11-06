fs = require 'graceful-fs'
path = require 'path'
nodefn = require 'when/node'
semver = require 'semver'

class File
  ###*
   * @class
   * @name File
   * @param {String} path The path to the file. This will be resolved to an
     absolute path, so even if you change your cwd you can still access the same
     file.
   * @param {String} [options.base=./] Used for relative pathing. This will not
     be resolved to an absolute path. Typically where a glob starts.
  ###
  constructor: (@path, options = {}) ->
    @base = options.base ? './'
    @_resolvePaths()

  ###*
   * Normalize & resolve paths. Call if the File.path changes
   * @function
   * @name _resolvePaths
   * @private
  ###
  _resolvePaths: ->
    @path = path.resolve(@base, @path)
    @relative = path.relative(@base, @path)

  ###*
   * Read from the file
   * @function
   * @name read
   * @param {String|null} [options.encoding=null]
   * @param {String} [options.flag='r']
   * @return {Promise}
  ###
  read: (options = {}) ->
    nodefn.call(fs.readFile, @path, @_processOptionsObject(options))

  ###*
   * Write `data` to the file
   * @function
   * @name write
   * @param {String|Buffer} data
   * @param {String|null} [options.encoding='utf8'] ignored if data is a
     buffer
   * @param {Number} [options.mode=438] default is 0666 in Octal
   * @param {String} [options.flag='w']
   * @return {Promise}
  ###
  write: (data, options = {}) ->
    nodefn.call(fs.writeFile, @path, data, @_processOptionsObject(options))

  ###*
   * Append `data` to the file
   * @function
   * @name append
   * @param {String|Buffer} data
   * @param {String|null} [options.encoding='utf8'] ignored if data is a
     buffer
   * @param {Number} [options.mode=438] default is 0666 in Octal
   * @param {String} [options.flag='w']
   * @return {Promise}
  ###
  append: (data, options = {}) ->
    nodefn.call(fs.appendFile, @path, data, @_processOptionsObject(options))

  ###*
   * Rename the file
   * @function
   * @name rename
   * @param {String} newPath The new path for the file. Will be resolved
     relative to File.base.
   * @return {Promise}
  ###
  rename: (newPath) ->
    newPath = path.resolve(@base, newPath)
    nodefn.call(fs.rename, @path, newPath).then( =>
      @path = newPath
      @_resolvePaths()
    )

  ###*
   * Delete the file
   * @function
   * @name unlink
   * @return {Promise}
  ###
  unlink: ->
    nodefn.call(fs.unlink, @path)

  ###*
   * Return a Stat object for the file
   * @function
   * @name stat
   * @return {Promise}
  ###
  stat: ->
    nodefn.call(fs.stat, @path)

  ###*
   * Get the extension of a file
   * @function
   * @name extname
   * @return {String}
  ###
  extname: ->
    path.extname(@path)

  ###*
   * Get the dirname of the file
   * @function
   * @name dirname
   * @return {String}
  ###
  dirname: ->
    path.dirname(@path)

  ###*
   * Determine if we're using the new version of the FS API that supports an
     options object.
   * @return {Boolean} True if the version is >= 0.10.0 (when the options object
     was introduced).
  ###
  _isOptionsObjectSupported: ->
    semver.gte(process.version, '0.10.0')

  ###*
   * The pre-v0.10.0 fs functions took a encoding parameter and no options
     object. This function deals with that difference.
   * @param {[type]} options [description]
  ###
  _processOptionsObject: (options) ->
    if @_isOptionsObjectSupported()
      options
    else
      optionNames = Object.keys(options)
      length = optionNames.length
      if length is 0 or (length is 1 and optionNames[0] is 'encoding')
        options.encoding
      else
        throw new Error("Node version <= 0.10.0 only supports an encoding
        option. Called with #{optionNames.join()}")

module.exports = File
