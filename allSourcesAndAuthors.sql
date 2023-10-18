use carrwi96;

SELECT s.*, j.journal_title, j.volume, j.issue, b.isbn, b.publisher, w.url, w.date_accessed
FROM source s
	LEFT JOIN journal j ON (j.source_id = s.source_id)
    LEFT JOIN book b ON (b.source_id = s.source_id)
    LEFT JOIN website w ON (w.source_id = s.source_id);
    
SELECT a.*, w.first_name, w.last_name, o.name as 'Organization Name'
FROM author a
	LEFT JOIN writer w ON (w.author_id = a.author_id)
    LEFT JOIN organization o ON (o.author_id = a.author_id);