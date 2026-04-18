#!/usr/bin/env nu

let directories = [
  "workspace/work-lsc@2"
  "workspace/work-protostar@1"
  "workspace/personal@1"
  "workspace/misc@1"
  ".config@1"
  "docker_files"
  "docker_volumes"
  "Desktop"
  "Downloads"
  "workspace/misc"
  "workspace/work-hashnetwork@1"
  "workspace/bruno-collections"
]

let entries = ($directories | each {|d|
  if ($d | str contains "@") {
    let p = ($d | split row "@")
    { rel: $p.0, depth: ($p.1 | into int), scan: true }
  } else {
    { rel: $d, depth: 0, scan: false }
  }
})

mut all = []

# Direct targets (no scan).
let fixed = (
  $entries
  | where scan == false
  | each {|e| $"($env.HOME)/($e.rel)" }
  | where {|p| $p | path exists }
)
$all = ($all | append $fixed)

# Scan targets grouped by depth, so fd is called once per depth.
let grouped = ($entries | where scan == true | group-by depth)
for col in ($grouped | columns) {
  let depth = ($col | into int)
  let roots = (
    $grouped
    | get $col
    | each {|e| $"($env.HOME)/($e.rel)" }
    | where {|p| $p | path exists }
  )
  if ($roots | is-empty) {
    continue
  }
  let found = (^fd --type d --exact-depth $depth . ...$roots | lines)
  $all = ($all | append $found)
}

let fzf_shell = (if ("/bin/zsh" | path exists) { "/bin/zsh" } else { "/bin/sh" })
let previous_shell = ($env | get -i SHELL | default "")
$env.SHELL = $fzf_shell
let res = ($all | uniq | str join (char nl) | ^fzf | str trim)
if ($previous_shell | is-empty) {
  hide-env SHELL
} else {
  $env.SHELL = $previous_shell
}
if ($res | is-empty) {
  return
}

let tmux_mode = ($env | get -i TMUX_SEARCH_MODE | default "")
if ($tmux_mode == "print") {
  print $res
  return
}

cd $res
if (([$res ".git"] | path join) | path exists) {
  ^nvim
}
