fs = require 'fs'
nodefn = require 'when/node'

# TODO: deal with file opening, closing, file descriptors...
class File
  constructor: (@path) ->

  ###*
   * Read from the file
   * @param {String|null} [options.encoding=null]
   * @param {String} [options.flag='r']
   * @return {Promise}
  ###
  read: (options={}) ->
    nodefn.call(fs.readFile, @path, options)

  ###*
   * Write `data` to the file
   * @param {String|Buffer} data
   * @param {String|null} [options.encoding='utf8'] ignored if data is a
     buffer
   * @param {Number} [options.mode=438] default is 0666 in Octal
   * @param {String} [options.flag='w']
   * @return {Promise}
  ###
  write: (data, options={}) ->
    nodefn.call(fs.writeFile, @path, data, options)

  ###*
   * Append `data` to the file
   * @param {String|Buffer} data
   * @param {String|null} [options.encoding='utf8'] ignored if data is a
     buffer
   * @param {Number} [options.mode=438] default is 0666 in Octal
   * @param {String} [options.flag='w']
   * @return {Promise}
  ###
  append: (data, options={}) ->
    nodefn.call(fs.appendFile, @path, data, options)

  ###*
   * Rename the file
   * @return {Promise}
  ###
  rename: (newPath) ->
    nodefn.call(fs.rename, @path, newPath).then( => @path = newPath)

  ###*
   * Delete the file
   * @return {Promise}
  ###
  unlink: ->
    nodefn.call(fs.unlink, @path)

  ###*
   * Return a Stat object for the file
   * @return {Promise}
  ###
  stat: ->
    nodefn.call(fs.stat, @path)

module.exports = File
