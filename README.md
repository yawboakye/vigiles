# Vigiles

Sometimes it helps to be able to examine, in totality, the request your
Rails application received, and the specific response it elicited. Very handy
when you're debugging. Also very handy when your engineers have to assist
non-technical customer support staff. That aside, it's generally a great
visualization of the black box abstraction, where your entire application is
seen as one logical function, taking input (request) and producing output
(response).

At the moment, this gem is unable to conduct you on your research journey from a
given request to its response: you'd have to call on your logs and other
observability systems you've engaged. But it's easy&mdash;rather,
possible&mdash;to see how we can bring this in house, with a little tracing.
