fs = require 'fs'
should = require 'should'
File = require '../lib'
CachedFile = require '../lib/cached'
sequence = require 'when/sequence'

describe 'File', ->
  before ->
    @testFile = new File('./test/testFile')

  it 'supports write', (done) ->
    @testFile
      .write('barfoo\n')
      .then( => @testFile.read(encoding: 'utf8'))
      .done((data) ->
        data.should.eql('barfoo\n')
        done()
      )

  it 'supports append', (done) ->
    @testFile
      .append('foobar\n')
      .then( => @testFile.read(encoding: 'utf8'))
      .done((data) ->
        data.should.eql('barfoo\nfoobar\n')
        done()
      )

  it 'supports read', (done) ->
    @testFile
      .read(encoding: 'utf8')
      .done((data) ->
        data.should.eql('barfoo\nfoobar\n')
        done()
      )

  it 'supports unlink', (done) ->
    @testFile
      .unlink()
      .done( =>
        fs.existsSync(@testFile.path).should.eql(false)
        done()
      )

  it 'sets File.path', ->
    @testFile.path.should.match(/\/test\/testFile$/)

  it 'sets File.relative', ->
    @testFile.relative.should.eql('test/testFile')

  it 'sets File.base', ->
    @testFile.base.should.eql('./')

describe 'CachedFile', ->
  before ->
    @testFile = new CachedFile('./test/testFile')

  it 'supports save', (done) ->
    @testFile.content = 'barfoo\n'
    @testFile
      .save()
      .then( => @testFile.read())
      .done((data) ->
        data.should.eql('barfoo\n')
        done()
      )

  it 'supports save (append)', (done) ->
    appendContent = 'foobar\n'
    @testFile.content += appendContent
    appendedContent = undefined

    @testFile.append = (data, options) ->
      appendedContent = data

    @testFile
      .save()
      .then( => @testFile.read())
      .done((data) ->
        appendedContent.should.eql(appendContent)
        done()
      )

  it 'supports load', (done) ->
    @testFile
      .load()
      .done((data) =>
        @testFile.content.should.eql('barfoo\n')
        done()
      )

  it 'supports unlink', (done) ->
    @testFile
      .unlink()
      .done( =>
        fs.existsSync(@testFile.path).should.eql(false)
        done()
      )

  it 'sets File.path', ->
    @testFile.path.should.match(/\/test\/testFile$/)

  it 'sets File.relative', ->
    @testFile.relative.should.eql('test/testFile')

  it 'sets File.base', ->
    @testFile.base.should.eql('./')
