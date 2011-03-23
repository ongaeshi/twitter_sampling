README.txt

---
1. Create a db.

$ sequel -m migration/ sqlite://twitter.db

---
2. Start sampling

$ ruby ./twitter_sampling.rb twitter.db

---




