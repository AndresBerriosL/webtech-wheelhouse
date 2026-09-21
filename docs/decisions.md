# Decisions

## 1. Do we need to keep the previous owners of a bike?

**Question:** If a bike is sold, should the system keep a history of its previous owners?

**Assumption:** For now, the bike only stores its current owner. Its repair history stays linked to the bike itself.

**If the answer is yes:** We would need another table to store the ownership history of each bike.


## 2. Does every repair need customer approval?

**Question:** Does the shop need approval before every repair, or only for some repairs?

**Assumption:** Simple repairs can be done directly, while bigger repairs may need a diagnosis and customer approval first.

**If the answer is that every repair needs approval:** Every repair would have to go through the approval states before work can begin.


## 3. Do we need to know which mechanic worked on a repair?

**Question:** Should the system record which mechanic worked on each repair?

**Assumption:** For now, repairs are not assigned to a specific mechanic.

**If the answer is yes:** We would need to store mechanics and connect them to repairs.