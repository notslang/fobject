W = require 'when'
path = require 'path'
{Stats} = require 'fs'

class FakeFile
  ###*
   * @type Buffer
   * @private
  ###
  _content: undefined

  ###*
   * @type Stats
   * @private
  ###
  _stats: undefined

  ###*
   * @class
   * @name File
   * @classdesc Represents a File that doesn't exist on the disk - all reads and
     writes just go to an internal property.
   * @param {String} path The path to the file. This will be resolved to an
     absolute path, so even if you change your cwd you can still access the same
     file.
   * @param {String} [options.base=./] Used for relative pathing. This will not
     be resolved to an absolute path. Typically where a glob starts.
  ###
  constructor: (@path, options = {}) ->
    @_content = new Buffer('')
    @_stats =
      dev: 0
      mode: 0 # TODO: set mode properly
      nlink: 0
      uid: 0
      gid: 0
      rdev: 0
      blksize: 0
      ino: 0
      size: 0
      atim_msec: new Date()
      mtim_msec: new Date()
      ctim_msec: new Date()
      birthtim_msec: new Date()

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
    W.resolve(
      if options.encoding?
        W.resolve(@_content.toString(options.encoding))
      else
        @_content
    )

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
    W.resolve().then( =>
      @_content = (
        if Buffer.isBuffer(data)
          data
        else
          new Buffer(data, options.encoding)
      )
    )

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
    W.resolve().then( =>
      data = (
        if Buffer.isBuffer(data)
          data
        else
          new Buffer(data, options.encoding)
      )
      @_content = Buffer.concat([@_content, data])
    )

  ###*
   * Rename the file
   * @function
   * @name rename
   * @param {String} newPath The new path for the file. Will be resolved
     relative to File.base.
   * @return {Promise}
  ###
  rename: (newPath) ->
    W.resolve().then( =>
      @path = path.resolve(@base, newPath)
      @_resolvePaths()
      @_stats.ctim_msec = new Date().now
    )

  ###*
   * Return a Stat object for the file
   * @function
   * @name stat
   * @return {Promise}
  ###
  stat: ->
    W.resolve().then( =>
      return new Stats(
        @_stats.dev
        @_stats.mode
        @_stats.nlink
        @_stats.uid
        @_stats.gid
        @_stats.rdev
        @_stats.blksize
        @_stats.ino
        @_stats.size
        @_stats.blocks
        @_stats.atim_msec
        @_stats.mtim_msec
        @_stats.ctim_msec
        @_stats.birthtim_msec
      )
    )

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

module.exports = FakeFile
