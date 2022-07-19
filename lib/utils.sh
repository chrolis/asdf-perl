echoerr() {
    >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_perl_install_setup() {
    ensure_perl_install_installed
}

ensure_perl_install_installed() {
    if [ ! -f "$(perl_install_bin)" ]; then
        download_perl_install
    elif is_perl_install_invalidated; then
        update_perl_install
    fi
}

download_perl_install() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    echoerr "Downloading perl-install..."

    git clone --depth 1 https://github.com/skaji/perl-install "$(perl_install_dir)" >&2 >/dev/null
}

update_perl_install() {
    echoerr "Updating perl-install..."

    (cd "$(perl_install_dir)" && git fetch  && git reset --hard origin/HEAD)
}

is_perl_install_invalidated() {
    local validate_timeout=604800  # one week
    local validate_file
    validate_file="$(perl_install_dir)/.git/FETCH_HEAD"

    if [ ! -f "$validate_file" ]; then return; fi  # true

    local last_update
    local current_timestamp
    last_update=$(date -r "$validate_file" +%s)
    current_timestamp=$(date +%s)

    local invalidated_at=$((last_update + validate_timeout))

    [ "$invalidated_at" -lt "$current_timestamp" ]
}

asdf_perl_plugin_path() {
    echo "$(dirname "$(dirname "$0")")"
}

perl_install_dir() {
    echo "$(asdf_perl_plugin_path)/perl-install"
}

perl_install_bin() {
    echo "$(perl_install_dir)/perl-install"
}
