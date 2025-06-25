FROM tomcat:11.0.8
WORKDIR /usr/local/tomcat
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]