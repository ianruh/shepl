# Shepl

Shell REPL. Requires zsh because I'm too lazy for shell comaptibility.

`shepl` is meant as a rapid prototyping tool to quickly construct and test
shell commands. You can use any shell, but it defaults to `/bin/bash`. Because
it executes commands as you type them, there is the risk of inadvertently
executing a destructive command. To mitigate this, all commands are run in a
read only environment by default (this can be bypassed using the `--unsafe`
flag). The implementation of this sandboxing is platform dependent.

## Install

Requires [fzf](https://github.com/junegunn/fzf). Download the executable:

```
curl -o /usr/local/bin/shepl https://raw.githubusercontent.com/ianruh/shepl/main/shepl
chmod +x /usr/local/bin/shepl
```

Or wherever you want to place it on your `PATH`.

### Vim Plugin

Requires [vim-floaterm](https://github.com/voldikss/vim-floaterm)

```
Plug 'voldikss/vim-floaterm'
Plug 'ianruh/shepl'
```

The only provided command is `Shepl`. Any selected text is passed to shepl's
stdin and is replaced by the output of shepl. Shepl takes an optional single
argument that can contain additional options to pass to shepl (such as a
command template).

**Config Options**

- `g:shepl_width` - The width passed to floaterm.
- `g:shepl_height` - The height passed to floaterm.

## Examples

### Manipulate Markdown Tables

You can use the vim plugin to quickly add computed columns to a markdown table.

[![asciicast](https://asciinema.org/a/590744.svg)](https://asciinema.org/a/590744)

### Starlink Satellites

Get the list of all Starlink satellites launched, their launch date, launch
site, and NORAD ID from [Space
Track](https://www.space-track.org/basicspacedata/query/class/satcat/OBJECT_TYPE/PAYLOAD/orderby/INTLDES%20asc/emptyresult/show).

*Note*: You need to make a free acount with Space Track to access the URL
above.

[![asciicast](https://asciinema.org/a/590514.svg)](https://asciinema.org/a/590514)

### Command Templates

**Query and Update a Markdown Table Using SQL**

```
$ alias md-sql="shepl -t 'md2csv | csvsql --db sqlite:// --insert --query {q} | csvlook'"
$ cat example_table.md | md-sql
```

*Notes*

- `csvsql` (from csvkit) creates a table named `stdin` in the in-memory
  database.
- Because `{q}` gets replaced literally, you need to have the query quoted or
  escpaed (e.g. `'select * from stdin'`)
- `md2csv` is a script to convert markdown tables to CSV. It lives in the `tools/`
  directory.
- This is more useful as a vim command (see below) when you can select a table
  in a markdown document and perform queries/edits on it.

<details>
<summary>Vim Command</summary>
<br>

```
:command -range MDSQL call Shepl('-t ''md2csv | csvsql --db sqlite:// --insert --query {q} | csvlook''')
```

</details>

**[cheat.sh](https://github.com/chubin/cheat.sh)**

```
function cht() { shepl -t 'curl -s http://cht.sh/$(echo {q} | sed "s/ /+/g")'; }
```

<details>
<summary>Vim Command</summary>
<br>

```
:command! -range Cheat call Shepl('-t ''curl -s http://cht.sh/$(echo {q} | sed "s/ /+/g")''')
```

</details>

## Options

```
Usage: shepl [options] [command]

A shell repl for rapid exploration & prototyping of commands. Pipe input to it,
rapidly iterate on your command, and then return the output when done.

If you find yourself working with one tool a lot and don't want to type a couple
extra characters, you can easily setup an alias using a default command template:
    
    $ alias jq-repl="shepl --template jq -C {q}"
    $ cat example.json | jq-repl

Options:
    --echo|-e       Echo the constructed commanded instead of executing
    --help|-h       Show this help message
    --template|-t   Treat the default command as a command template. '{q}' in
                    the command is replaced by what is typed into the prompt.
    --shell path    Path of the shell command to use. Default /bin/bash
    --unsafe        Allow unsafe shell execution

Key Bindings:
    enter           Confirm the current command
    ctrl-/          Show this help message in the preview window
    ctrl-u          Scroll the preview window half page up
    ctrl-d          Scroll the preview window half page down
    ctrl-r          View history
    tab             Scroll to next history item
    shift-tab       Scroll to preview history item
    alt-enter       Replace command with focused command from history
    alt-bspace      Clear the current command

    [Default FZF bindings including...]
    ctrl-c          Exit

Example:

    Quickly select a subset of fields from a JSON file by piping it through shepl
    and constructing a jq query in real time. When you are happy with the query,
    confirm the command, and the output will be written to selection.json.
    
        $ cat example.json | shepl > selection.json

    Prototype a regex expression by piping your input to shepl and using grep, rg,
    or your choice of engine, and seeing the output live as you type. Using the
    -e option, you can copy the final command to your clipboard when you are done.

        $ cat lotr.txt | shepl -e | pbcopy
        $ pbpaste
        rg '.*Bilbo said.*' 

Internal Options:
    --exec inputfile command...   Execute the given command, with inputfile piped
                                  to it in a jail.

Jailing:
    
    Jails are implemented differently depening on the system. They aren't true jails
    and should not be trusted. They are intended as a first line of defence against
    accidentally destroying your system.

    MacOS - Using sandbox-exec
```
