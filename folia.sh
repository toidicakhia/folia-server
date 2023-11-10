#!/bin/bash

# Enter server directory
cd folia

# Set nullstrings back to 'latest'
: ${MC_VERSION:='latest'}
: ${FOLIA_BUILD:='latest'}

# Lowercase these to avoid 404 errors on wget
MC_VERSION="${MC_VERSION,,}"
FOLIA_BUILD="${FOLIA_BUILD,,}"

# Get version information and build download URL and jar name
URL='https://papermc.io/api/v2/projects/folia'
if [[ $MC_VERSION == latest ]]
then
  # Get the latest MC version
  MC_VERSION=$(wget -qO - "$URL" | jq -r '.versions[-1]') # "-r" is needed because the output has quotes otherwise
fi
URL="${URL}/versions/${MC_VERSION}"
if [[ $FOLIA_BUILD == latest ]]
then
  # Get the latest build
  FOLIA_BUILD=$(wget -qO - "$URL" | jq '.builds[-1]')
fi
JAR_NAME="folia-${MC_VERSION}-${FOLIA_BUILD}.jar"
URL="${URL}/builds/${FOLIA_BUILD}/downloads/${JAR_NAME}"

# Update if necessary
if [[ ! -e $JAR_NAME ]]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  wget "$URL" -O "$JAR_NAME"
fi

# Update eula.txt with current setting
echo "eula=${EULA:-false}" > eula.txt

# Add RAM options to Java options if necessary
if [[ -n $MC_RAM ]]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} $JAVA_OPTS"
fi

# Start server
exec java -server $JAVA_OPTS -jar "$JAR_NAME" nogui
