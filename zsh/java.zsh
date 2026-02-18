# export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export JAVA_11_HOME=$(/usr/libexec/java_home -v 11)
export JAVA_17_HOME=$(/usr/libexec/java_home -v 17)
alias switch-java-11="export JAVA_HOME=`/usr/libexec/java_home -v 11` && java --version"
alias switch-java-17="export JAVA_HOME=`/usr/libexec/java_home -v 17` && java --version"

