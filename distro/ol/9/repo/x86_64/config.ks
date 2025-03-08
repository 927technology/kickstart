# YUM Repisitories
#repo --name="baseos" --baseurl="https://public-yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/"
#repo --name="UEKR7" --baseurl="https://public-yum.oracle.com/repo/OracleLinux/OL9/UEKR7/x86_64/"
#repo --name="AppStream" --baseurl="https://public-yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/"

repo --name="ol9_baseos_latest" --baseurl="https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/baseos/latest/$basearch/
repo --name="ol9_appstream" --baseurl="https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/appstream/$basearch/
repo --name="ol9_UEKR7" --baseurl="https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/UEKR7/$basearch/

# repo --name="ol9_AppStream" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/"
# repo --name="ol9_UEKR7" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL9/UEKR7/x86_64/"


#repo --name="Oracle Linux 9 UEK Release 7 x86_64" --baseurl="https://yum$ociregion.$ocidomain/repo/OracleLinux/OL9/UEKR7/$basearch/"
#repo --name="Oracle Linux 9 BaseOS Latest (x86_64)" --baseurl="https://yum$ociregion/$ocidomain/repo/OracleLinux/OL9/baseos/latest/$basearch/"
#repo --name="Oracle Linux 9 Application Stream Packages (x86_64)" --baseurl="https://yum$ociregion/$ocidomain/repo/OracleLinux/OL9/appstream/$basearch/"