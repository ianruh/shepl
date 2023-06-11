" vim:sw=2:
" ============================================================================
" FileName: shepl.vim
" Author: ianruh <ianruh2@gmail.com>
" GitHub: https://github.com/ianruh
" ============================================================================

if exists("g:loaded_shepl")
    finish
endif
let g:loaded_shepl = 1

" Figure out the path to the plugin directory so we can use it later
let s:plugindir = expand('<sfile>:p:h:h')

" Config variables
let g:shepl_width = 0.8
let g:shepl_height = 0.8

function Shepl(...) range
    " Save the select text to an input file
    let s:input_file = tempname()

    let [s:line_start, s:column_start] = getpos("'<")[1:2]
    let [s:line_end, s:column_end] = getpos("'>")[1:2]
    let lines = getline(s:line_start, s:line_end)
    if len(lines) == 0
        return
    endif
    "edge cases and cleanup.
    let lines[-1] = lines[-1][: s:column_end - 2]
    let lines[0] = lines[0][s:column_start - 1:]
    let selected_text = join(lines, "\n")

    call writefile(split(selected_text, "\n"), s:input_file)

    " Output file name
    let s:output_file = tempname()

    let cmd = 'cat "'.s:input_file.'" | '.s:plugindir.'/shepl '
    if a:0 > 0
        let cmd = cmd . a:1
    endif
    let cmd = cmd . ' > "'.s:output_file.'"'
    let jobopts = {}
    let jobopts['on_exit'] = funcref('s:shepl_callback')
    let config = {}
    let config['title'] = 'shepl'
    let config['name'] = 'shepl'
    let config['width'] = g:shepl_width
    let config['height'] = g:shepl_height
    let config['borderchars'] = '─│─│╭╮╯╰'
    call floaterm#new(v:null, cmd, jobopts, config)

endfunction

function! s:shepl_callback(job, data, event, opener) abort
    if filereadable(s:output_file)
        let output = readfile(s:output_file)
        if !empty(output)
            call deletebufline(bufnr("%"), s:line_start, s:line_end)
            call append(s:line_start-1, output)
        endif
    endif
endfunction

command -range -nargs=? Shepl call Shepl(<f-args>)
