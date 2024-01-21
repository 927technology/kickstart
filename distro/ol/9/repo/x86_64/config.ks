# YUM Repisitories
#repo --name=baseos --baseurl=https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/baseos/latest/$basearch
#repo --name=appstream --baseurl=https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/appstream/$basearch

#repo --name="ol9_AppStream" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/"
#repo --name="ol9_UEKR7" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL9/UEKR7/x86_64/"

repo --name="ol9_UEKR7" --baseurl="https://public-yum.oracle.com/repo/OracleLinux/OL9/UEKR7/x86_64/"
repo --name="ol9_AppStream" --baseurl="https://public-yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/"
