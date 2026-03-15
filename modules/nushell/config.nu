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
$env.config.completions.external = {
  enable: true
  max_results: 100
  completer: {|spans|
    # Expand alias
    mut spans = $spans 
    | skip 1
    | prepend (
      scope aliases
      | where name == $spans.0
      | get expansion
      | get -i 0
      | default $spans.0
      | split row " "
      | first
    )
    
    # nix-your-shell completion script passthrough
    if ($spans | first 2) == [nix-your-shell nu] {
      $spans = $spans | skip 2
    }

    carapace $spans.0 nushell ...$spans | from json
  }
}

load-env {
  CARAPACE_EXCLUDES: "nix"
  CARAPACE_BRIDGES: "zsh,fish,bash"
}

alias nix = nix-your-shell nu nix --
alias nix-shell = nix-your-shell nu nix-shell --

$env.SHELL = "nu"
