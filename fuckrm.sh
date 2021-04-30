#! /bin/bash
# 使用mv命令代替rm

trashPath="${HOME}/.trash/"
deleteDayBefore=180

rm() {
    date=$( date +'%Y-%m-%d' )
    dir="${trashPath}${date}/"
    if [[ ! -d ${dir} ]]; then
        mkdir -p ${dir}
    fi
    removeExpiredDir 
    params=''
    for p in $@; do
        if [[ ${p:0:1} != '-' ]]; then
            params="${params} ${p}"
        fi
    done
    mv ${params} ${dir}
}

removeExpiredDir() {
    now=$( date +%s )

    for d in $( ls ${trashPath} ); do
        dTime=$( date -d ${d} +%s )
        if [[ ($? == 0) && $(( (${now} - ${dTime}) / 86400)) -ge ${deleteDayBefore} ]]; then
            /bin/rm -rf ${trashPath}${d}
        fi
    done
}
