fs = require 'fs'
nodefn = require 'when/node'

# TODO: deal with file opening, closing, file descriptors...
class File
  constructor: (@filename) ->

  ###*
   * Read from the file
   * @param {String|null} [options.encoding=null] ignored if data is a buffer
   * @param {String} [options.flag='r']
   * @return {Promise}
  ###
  read: (options={}) ->
    nodefn.call(fs.readFile, @filename, options)

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
    nodefn.call(fs.writeFile, @filename, data, options)

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
    nodefn.call(fs.appendFile, @filename, data, options)

module.exports = File

###
rename(oldPath, newPath, callback)
ftruncate(fd, len, callback)
truncate(path, len, callback)
chown(path, uid, gid, callback)
fchown(fd, uid, gid, callback)
lchown(path, uid, gid, callback)
chmod(path, mode, callback)
fchmod(fd, mode, callback)
lchmod(path, mode, callback)
stat(path, callback)
lstat(path, callback)
fstat(fd, callback)
link(srcpath, dstpath, callback)
symlink(srcpath, dstpath, [type], callback)
readlink(path, callback)
realpath(path, [cache], callback)
unlink(path, callback)
rmdir(path, callback)
mkdir(path, [mode], callback)
readdir(path, callback)
close(fd, callback)
open(path, flags, [mode], callback)
utimes(path, atime, mtime, callback)
futimes(fd, atime, mtime, callback)
write(fd, buffer, offset, length, position, callback)
read(fd, buffer, offset, length, position, callback)

readFile(filename, [options], callback)
writeFile(filename, data, [options], callback)
appendFile(filename, data, [options], callback)

watchFile(filename, [options], listener)
unwatchFile(filename, [listener])
watch(filename, [options], [listener])
###
