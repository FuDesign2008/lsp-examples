



" @param {String} fileName
" @param {Integer} limitTimes
" @return {Object}
function VueFindFileUp(fileName, limitTimes)
    let l:tempDir = fnamemodify(getcwd(), ':p:h')
    let l:tempFile = ''
    let l:counter = 0
    let l:isExist = 0
    let l:result = {}

    while l:counter <= a:limitTimes
        let l:tempFile = l:tempDir . '/' . a:fileName
        let l:isExist = filereadable(l:tempFile)
        if l:isExist
            let l:result['file'] = l:tempFile
            let l:result['filename']= a:fileName
            let l:result['distance']  =  l:counter
            return l:result
        endif
        let l:tempDir = fnamemodify(l:tempDir, ':p:h:h')
        let l:counter = l:counter + 1
    endwhile

    return l:result
endfunction

" @return {2|3}
function VueDetectVersion()
    let found =  VueFindFileUp('package.json', 15)
    let file = get(found, 'file', '')
    let l:version = 2
    if empty(file)
        return l:version
    endif
    let lines = readfile(file)
    let content = join(lines, '')
    let data = json_decode(content)
    let dependencies = get(data, 'dependencies', {})
    let vue = get(dependencies, 'vue', '^2.0.0')
    " vue value may  '^3.x.y' or '3.x.y'
    if match(vue, '\^3\.') == 0 || match(vue, '3\.') == 0
        l:version = 3
    endif

    return l:version
endfunction



let g:ycm_language_server += [
  \   { 'name': 'vue',
  \     'filetypes': [ 'vue' ],
  \     'cmdline': [ expand( g:ycm_lsp_dir . '/vue/node_modules/.bin/' . (VueDetectVersion() == 2 ? 'vls' : 'vue-language-server') ) ]
  \   },
  \ ]
