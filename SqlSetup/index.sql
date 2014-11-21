/* Create the 3 indices required*/
create index indexSubject on images(subject) indextype is ctxsys.context;
create index indexPlace on images(place) indextype is ctxsys.context;
create index indexPlace on images(description) indextype is ctxsys.context;
