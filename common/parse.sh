strip() {
    local str=$1

    str="${str##+([[:space:]])}" # Strips leading spaces
    str="${str%%+([[:space:]])}" # Strips trailing spaces

    echo ${str}
}

parse_config() {
    local config=$1

    while read line
    do
        IFS='=' read key value <<<${line}
        key=$(strip "${key}")
        value=$(strip "${value}")
        local -n target="${key}"
        target="${value}"
    done < "${config}"
}
