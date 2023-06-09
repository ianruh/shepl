# Shepl

Shell REPL. Requires zsh because I'm too lazy for shell comaptibility.

## Download

```
$ curl -o /usr/local/bin/shepl https://raw.githubusercontent.com/ianruh/shepl/main/shepl && chmod +x /usr/local/bin/shepl
```

## Examples

### Starlink Satellites

Get the list of all Starlink satellites launched, their launch date, launch
site, and NORAD ID from [Space
Track](https://www.space-track.org/basicspacedata/query/class/satcat/OBJECT_TYPE/PAYLOAD/orderby/INTLDES%20asc/emptyresult/show).

*Note*: You need to make a free acount with Space Track to access the URL
above.

[![asciicast](https://asciinema.org/a/590514.svg)](https://asciinema.org/a/590514)
