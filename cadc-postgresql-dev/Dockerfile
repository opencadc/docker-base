FROM centos:7 

# install required software
RUN yum update -y
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
COPY src/cadc.repo /etc/yum.repos.d/
RUN  yum -y install postgresql10-server-10.9-1PGDG.rhel7 postgresql10-contrib-10.9-1PGDG.rhel7 postgresql10-devel-10.9-1PGDG.rhel7 pgsphere10
RUN yum clean all

RUN mkdir -p /logs
COPY src/init/* /var/lib/pgsql/10/

COPY src/cadc-dev-postgresql-start /usr/bin/
CMD ["/usr/bin/cadc-dev-postgresql-start"]

