HUGO=/usr/local/sbin/hugo
$HUGO server --watch=true --source="/src" --destination="/output" --bind="0.0.0.0" "$@" || exit 1
