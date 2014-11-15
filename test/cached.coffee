fs = require 'fs'
CachedFile = require '../lib/cached'

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
