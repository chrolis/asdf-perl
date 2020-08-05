PERL_BUILD_VERSION="${ASDF_PERL_BUILD_VERSION:-1.31}"
PERL_BUILD_TAG="${PERL_BUILD_VERSION}"

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
            # If the perl-build directory already exists and the version does not
            # match, remove it and download the correct version
            rm -rf "$(perl_build_dir)"
            download_perl_build
        fi
    fi
}

download_perl_build() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    echoerr "Downloading perl-build..."
    local build_dir="$(perl_build_dir)"

    # Clone down and checkout the correct perl-build version
    git clone https://github.com/tokuhirom/Perl-Build.git $build_dir >&2 >/dev/null
    (cd $build_dir; git checkout $PERL_BUILD_TAG >&2 >/dev/null)
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
