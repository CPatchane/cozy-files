client = require "../helpers/client"

module.exports = class File extends Backbone.Model

    urlRoot: ->
        if @get("isFolder") 
            'folders/'
        else
            'files/'

    validate: (attrs, options) ->

        errors = []
        if not attrs.name or attrs.name is ""
            errors.push
                field: 'name'
                value: "A name must be set."

        if errors.length > 0
            return errors
        return 

    prepareCallbacks: (callbacks, presuccess, preerror) ->
        {success, error} = callbacks or {}
        presuccess ?= (data) => @set data.app
        @trigger 'request', @, null, callbacks
        callbacks.success = (data) =>
            presuccess data if presuccess
            @trigger 'sync', @, null, callbacks
            success data if success
        callbacks.error = (jqXHR) =>
            preerror jqXHR if preerror
            @trigger 'error', @, jqXHR, {}
            error jqXHR if error

    repository: ->
        rep = (@get("path") + "/" + @get("name"))
        if rep == "/"
            rep = ""
        rep

    # FOLDER
    # get the thing
    find: (callbacks) ->
        @prepareCallbacks callbacks
        client.get "folders/#{@id}", callbacks

    # Get application description
    findFiles: (callbacks) ->
        @prepareCallbacks callbacks
        client.get "folders/#{@id}/files", callbacks

    # Get application description
    findFolders: (callbacks) ->
        @prepareCallbacks callbacks
        client.get "folders/#{@id}/folders", callbacks

    # FILE
    # get file attachement
    getAttachment: (file, callbacks) ->
        @prepareCallbacks callbacks
        client.post "files/#{@id}/getAttachment/#{@name}", callbacks