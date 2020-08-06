PERL_BUILD_VERSION="${ASDF_PERL_BUILD_VERSION:-1.31}"

echoerr() {
    >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_perl_build_setup() {
    ensure_perl_build_installed
}

ensure_perl_build_installed() {
    local perl_build_version

    if [ ! -f "$(perl_build_path)" ]; then
        download_perl_build
    else
        current_perl_build_version="$("$(perl_build_path)" --version | cut -d ' ' -f2)"
        if [ "$current_perl_build_version" != "$PERL_BUILD_VERSION" ]; then
            update_perl_build
        fi
    fi
}

download_perl_build() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    echoerr "Downloading perl-build..."
    local build_dir="$(perl_build_dir)"

    # Clone down and checkout the correct perl-build version
    git clone https://github.com/tokuhirom/Perl-Build.git $build_dir >&2 >/dev/null
    checkout_perl_build
}

update_perl_build() {
    echoerr "Updating perl-build..."
    local build_dir="$(perl_build_dir)"
    (cd $build_dir; git checkout master; git pull)
    checkout_perl_build
}

checkout_perl_build() {
    local build_dir="$(perl_build_dir)"
    (cd $build_dir; git checkout $(git rev-list --topo-order ${PERL_BUILD_VERSION}..HEAD | tail -1) >&2 >/dev/null)
}

switch_perl_build() {
    local build_dir="$(perl_build_dir)"
}

asdf_perl_plugin_path() {
    echo "$(dirname "$(dirname "$0")")"
}

perl_build_dir() {
    echo "$(asdf_perl_plugin_path)/perl-build"
}

perl_build_path() {
    echo "$(perl_build_dir)/perl-build"
}
