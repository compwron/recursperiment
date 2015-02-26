Recurring billing
====

* This is an experiment
* never put this in prod

Development
====

* ```bundle install``` to install dependencies
* ```rspec``` to run tests
* ```rackup``` to run server
* server config in ```config.ru```
* is the server up? ```http://localhost:9292/heartbeat```



While it seems simple at first, recurring billing is actually quite complicated. For example, a subscription can be past due for several months, accruing a balance. Then, when the credit card is updated, or the merchant chooses to wipe the balance, we need to reactivate the subscription and get it back into the monthly billing cycle. This involves updating the balance, paid_through_date, next_billing_date, billing_period and more.