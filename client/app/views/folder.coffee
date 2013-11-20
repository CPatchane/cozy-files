BaseView = require '../lib/base_view'
FilesView = require './files'
BreadcrumbsView = require "./breadcrumbs"
ProgressbarView = require "./progressbar"
ModalView = require "./modal"

File = require '../models/file'
FileCollection = require '../collections/files'


module.exports = class FolderView extends BaseView

    template: require './templates/folder'

    events: ->  
        'click #new-folder-send': 'onAddFolder'
        'click #upload-file-send': 'onAddFile'
        'click a#button-new-folder': 'prepareNewFolder'
        'keydown input#inputName' : "onKeyPress"

    constructor: (@model, @breadcrumbs) ->
        super()
        @breadcrumbs.setRoot @model

    render: ->
        @beforeRender()
        @$el.html @template model:@model
        @afterRender()
        @

    afterRender: ->
        super()

        # add breadcrumbs view
        @breadcrumbsView = new BreadcrumbsView @breadcrumbs
        @$("#crumbs").append @breadcrumbsView.render().$el


    changeActiveFolder: (folder) ->

        # save the model
        @model = folder
        # update breadcrumbs
        @breadcrumbs.push folder
        # files
        @displayChildren()


    displayChildren: ->

        # add files view
        @model.findFiles
            success: (files) =>

                @model.findFolders
                    success: (folders) =>

                        # mark folders as folders
                        for folder in folders
                            folder.isFolder = true

                        # new collection
                        @stopListening @filesCollection, "progress:done"
                        @filesCollection = new FileCollection files.concat(folders)
                        @listenTo @filesCollection, "progress:done", @hideUploadForm

                        # render the collection
                        @filesList = new FilesView @filesCollection, @model

                        
                        @$('#files').html @filesList.$el
                        @filesList.render()

                    error: (error) =>
                        console.log error
                        new ModalView "Error", "Error getting folders from server", "OK"
            error: (error) =>
                console.log error
                new ModalView "Error", "Error getting files from server", "OK"


    onAddFolder: =>
        folder = new File
            name: @$('#inputName').val()
            path: @model.repository()
            isFolder: true
        console.log "creating folder #{folder}"

        if folder.validate()
            new ModalView "Error", "Folder name can't be empty", "OK"
        else
            @filesList.addFolder folder
            # hide modal
            $('#dialog-new-folder').modal('hide')

    onAddFile: =>
        for attach in @$('#uploader')[0].files
            @filesList.addFile attach

    onKeyPress: (e) =>
        if e.keyCode is 13
            @onAddFolder()

    hideUploadForm: ->
        $('#dialog-upload-file').modal('hide')

    prepareNewFolder: ->
        setTimeout () =>
            @$("#inputName").focus()
        , 500