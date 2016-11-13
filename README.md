# OvTijdCore

A starting point for building an app to look at the departure times for public transit in The Netherlands. 

Many thanks to ovapi.nl for providing an api to play around with!
Thanks to SwiftyJSON for their great work!

# Refactor possibilities
The parsing of objects like PassDetails should be moved to class/struct extensions to reduce coupling between used libraries and the model.
