
use carrwi96;

select * 
from source 
	left join journal using (source_id)
	left join website using (source_id)
	left join book using (source_id) ;

select * from author a join `writer` w on (a.author_id = w.author_id) ;

SELECT * FROM carrwi96.coauthor ;

select * from author a join `organization` o on (a.author_id = o.author_id) ;

show create table author;
show create table book;
show create table cite_source_paper;
show create table coauthor;
show create table journal;
show create table organization;
show create table paper;
show create table source;
show create table website;
show create table writer;