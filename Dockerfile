FROM registry.access.redhat.com/redhat-sso-7/sso72-openshift

LABEL maintainer='John Lee <jolee@redhat.com>'

COPY /modules /addon/modules
COPY /extensions /extensions

# Prepare JBOSS for configuration
ENV DEFAULT_LAUNCH $JBOSS_HOME/bin/openshift-launch.sh
ENV DEFAULT_LAUNCH_NOSTART $JBOSS_HOME/bin/openshift-launch-nostart.sh
RUN cp $DEFAULT_LAUNCH $DEFAULT_LAUNCH_NOSTART
RUN sed -i 's/standalone.sh/echo/' $DEFAULT_LAUNCH_NOSTART
RUN sed -i 's/wait/echo/' $DEFAULT_LAUNCH_NOSTART
RUN $DEFAULT_LAUNCH_NOSTART

# Configure JBoss
RUN $JBOSS_HOME/bin/jboss-cli.sh --file=/extensions/actions.cli

RUN $DEFAULT_LAUNCH