FROM fedora:36

RUN dnf -y update \
    && curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - \
    && dnf install -y nodejs \
    && dnf -y install gcc-c++ make \
    && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
    && dnf -y install yarn
