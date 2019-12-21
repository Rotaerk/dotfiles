remove-hooks global kakrc

set-option global indentwidth 2
set-option global writemethod replace

hook -group kakrc global InsertChar \t %{ try %{
  execute-keys -draft h %opt{indentwidth}@
} }

map global insert <backspace> ⌫
hook -group kakrc global InsertChar ⌫ %{ try %{
  execute-keys <backspace>
  try %{
    execute-keys -draft hGh <a-k>\A\h+\z<ret> <lt>
  } catch %{
    execute-keys <backspace>
  }
} }

map global user p '<a-!>xsel -op<ret>'
map global user P '!xsel -op<ret>'
map global user v 'i<ret><esc>h!xsel -op<ret>uUyup'
map global user V 'i<ret><esc>h!xsel -op<ret>uUyuP'
map global user R 'd!xsel -op<ret>'
map global user y '<a-|>xsel -ip<ret>'

# Basic autoindent.
def -hidden basic-autoindent-on-newline %{
  eval -draft -itersel %{
    try %{ exec -draft ';K<a-&>' }                      # copy indentation from previous line
    try %{ exec -draft ';k<a-x><a-k>^\h+$<ret>H<a-d>' } # remove whitespace from autoindent on previous line
  }
}
def basic-autoindent-enable %{
  hook -group basic-autoindent window InsertChar '\n' basic-autoindent-on-newline
  hook -group basic-autoindent window WinSetOption 'filetype=.*' basic-autoindent-disable
}
def basic-autoindent-disable %{ rmhooks window basic-autoindent }

hook global WinCreate .* %{
  basic-autoindent-enable
}
