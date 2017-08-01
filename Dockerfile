FROM dblackdblack/x-dockerbase:latest

COPY ["requirements.txt", "/app/"]

RUN pip3 install -r /app/requirements.txt

RUN pg_createcluster --locale en_US.UTF-8 --start ${POSTGRES_VERSION} main \
  && su - postgres -c "createuser --superuser dbuser" \
  && su - postgres -c "psql -c\"alter user dbuser with password 'secret123'\"" \
  && su - postgres -c "createdb --owner dbuser --locale en_US.UTF-8 db" \
  && service postgresql stop

COPY ["app", "/app/app/"]

ENV DATABASE_URL=postgresql://dbuser:secret123@localhost:5432/db
COPY ["cmd.sh", "db.pg_dump", "/"]
RUN service postgresql start \
  && su - postgres -c "pg_restore -d db /db.pg_dump" \
  && service postgresql stop \
  && echo 'Annabel3376779@example.com' > /user_to_find

EXPOSE 8000
CMD ["/cmd.sh"]
