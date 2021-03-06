# This image extends plussell/base-wildfly image
# with mail configuration
FROM plussell/base-wildfly

MAINTAINER plussell <devteam@plussell.org>

ENV WILDFLY_STANDALONE_CFG $JBOSS_HOME/standalone/configuration/standalone.xml

# Coping file
COPY files /opt/liferay/files

# Change owner of files
USER root
RUN chown -R liferay:liferay /opt/liferay/files && \
    chmod -R 0755 /opt/liferay/files
USER liferay

# configure mail server
RUN cd $HOME && \
    sed -i -e '/<socket-binding-group/ r /opt/liferay/files/socket-binging-group.xml' $WILDFLY_STANDALONE_CFG && \
    sed -i -e '/<profile>/ r /opt/liferay/files/subsystem.xml' $WILDFLY_STANDALONE_CFG

# Cleanup
#USER root
#RUN rm -rf /opt/liferay/files
#USER liferay

EXPOSE 8080 9990

CMD ["/opt/liferay/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
