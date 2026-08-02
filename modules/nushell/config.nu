def _custom_ctrlw [] {
  let old_commandline = commandline
  let old_cursor = commandline get-cursor

  let delete_count = $old_commandline
  | str substring 0..<$old_cursor
  | str reverse 
  | parse --regex r#'(?<delete>\s*([\w-]+|.)).*'#
  | get delete
  | if ($in | length) > 0 { first | str length } else { 0 }

 let new_cursor = $old_cursor - $delete_count
 let new_commandline = ($old_commandline | str substring 0..<$new_cursor) + ($old_commandline | str substring $old_cursor..)
 commandline edit $new_commandline
 commandline set-cursor $new_cursor
}

$env.config.show_banner = false
$env.config.keybindings = [
  {
    modifier: control
    keycode: char_w
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "_custom_ctrlw"
    }
  }
]
$env.SHELL = "nu"


# https://www.nushell.sh/cookbook/external_completers.html
let fish_completer = {|spans|
  fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
  | from tsv --flexible --noheaders --no-infer
  | rename value description
  | update value {|row|
    let value = $row.value
    let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
    if ($need_quote and ($value | path exists)) {
      let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
      $'"($expanded_path | str replace --all "\"" "\\\"")"'
    } else {$value}
  }
}
let carapace_completer = {|spans: list<string>|
  CARAPACE_BRIDGES="fish,zsh,bash" carapace $spans.0 nushell ...$spans | from json
}

let external_completer = {|spans|
  match $spans.0 {
  # Carapace installable completion are meh
  nix => $fish_completer
  _ => $carapace_completer
} | do $in $spans
}

$env.config = {
  completions: {
    external: {
      enable: true
      completer: $external_completer
    }
  }
}
