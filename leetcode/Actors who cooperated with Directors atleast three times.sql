CREATE TABLE
    ActorDirector (
        actor_id INT,
        director_id INT,
        timestamp TIMESTAMP,
        PRIMARY KEY (timestamp)
    );

Select actor_id, director_id
from actordirector
group by
    actor_id,
    director_id
having count(*) >= 3