# work dir
export home="/Users/fnfly2005/Documents"
export public_home="/Users/fnfly2005/public_work"
export private_home="/Users/fnfly2005/private_work"

# jenv java版本管理
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# jdk 环境变量
# JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-10.0.2.jdk/Contents/Home 写死路径法
# export JAVA_HOME=/usr/libexec/java_home 取JDK最新安装路径法
export JAVA_HOME=$(/usr/libexec/java_home -v $(jenv version-name)) # 取jenv 环境法
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/liba:$HOME/javaclass
export PATH=$JAVA_HOME/bin:$PATH

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# added by Anaconda2 5.2.0 installer
export PATH="/Users/fnfly2005/anaconda2/bin:$PATH"

