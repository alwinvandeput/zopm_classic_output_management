# ZOPM - Classic Output Management
The name of your package should be ZOPM.
This package is all about making the Classic Output Management (DB tables NAST and TNAPR) applicable for OO design.

The procedural way of programming was to program all the logic for reading the data, creating the document, sending an email, sending an IDoc and so on in the print program. However in the Object Oriented way this should be moved the Business Object class.

Therefor the print program does not have to be copied any more.
The TNAPR contains the Application type and the Business Object type, so it can determine which Business Object class must be used.

This framework is all generic for calling the Business Object class.

# Prerequisites
- https://github.com/alwinvandeput/zbo_generic_business_object

# Example
For fully working example also install package zsd_sales_and_distribution.

https://github.com/alwinvandeput/zsd_sales_and_distribution
