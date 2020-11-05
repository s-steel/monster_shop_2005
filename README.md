# Monster Shop
BE Mod 2 Week 4/5 Group Project

Forked repository from the [Turing School](https://turing.io/) monster_shop_2005 project.


![Lets Go Shopping!](https://media4.giphy.com/media/fAhOtxIzrTxyE/100w.webp?cid=5a38a5a2z1n7c9tmo61y6h70io7n885gb8om5v4lsjyycsyo&rid=100w.webp)




Collaboration between: [Zach Sterns](https://github.com/Stearnzy), [Aiden Murray](https://github.com/TeknoServal), and [Sean Steel](https://github.com/s-steel)


## Check it out [Here!](https://immense-plateau-02889.herokuapp.com/)


## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

This is a short explaination of each piece of functionality that we implemented.


### Table of Contents
***
**[Database Schema](#database-schema)**<br>
**[Navigation](#navigation)**<br>
**[User Registration](#user-registration)**<br>
**[Login/Logout](#login-logout)**<br>
**[Items](#items)**<br>
**[User Profile](#user-profile)**<br>
**[Shopping Cart & Checkout](#shopping-cart-and-checkout)**<br>
**[Orders](#orders)**<br>
**[Merchant Actions](#merchant-actions)**<br>
**[Order Fulfillment](#order-fulfillment)**<br>
**[Admin Actions](#admin-actions)**<br>
**[Next Time](#next-time)**<br>

## Schema

![Database Schema][logo]
[logo]: https://turingschool.slack.com/files/U014UE45P7Y/F01EUSTHW64/monster_shop_database_schema.png

## Navigation

This is examining the navigation bar on the top of each page.  It presents links and information for the users of the site.  We tested the presence of this navigation bar and its functionality depending on what type of user was on the site, and its persistence throughout the whole site.  A visitor, a user, a merchant, and an admin are each presented with different links and different information on their navigation bar.  Along with this there are certain restrictions for each user depending on their access level.

## User Registration

This section allows a user to register on our site.  A user is able to enter in their information and register for the site, and their password is encrypted using BCrypt.  User must enter in their information completely and have a unique email address.  Each user that is registered on the site is given a `role` which is represented by an integer.  We then used `enum` within the user model to assign a string which represented their access level ie. `admin`, `merchant_employee`, or `default`.  We then also added an option `merchant_id` attribute for each user.  This was only used for merchant employees to be able to indentify which employee belonged to which merchant.  We also implemented `before_action` in merchant and admin controllers to control who was able to access certain actions.

## Login/Logout

Users can login and logout, and cannot login with bad credentials.  When logging in and logging out the user is redirected to their profile page or dashboard depending on their role.  When logging in, logging out, or entering bad credentials they see flash messages explaining what happened.

## Items

This is the main shopping page.  Visitors and regular users are able to browse all the items that are available for purchase as well as see some statistics about the items.  Items were assigned an `active?` attribute that we used to determine if visitors and regular users were able to view these.  Merchants are then able to activate or deactivate their items.

## User Profile

A regular user is able to login and see all their information with the exception of their password on their profile page.  They cannot see their password because it is encrypted before being stored in the database.  Users are able edit their information, password, and email as long as the new email address is not already in the system.  Admins are able to see all the registered users of the site, but not merchant or admin users.

## Shopping Cart & Checkout

This is where you make the money!  Here a user can put items in a shopping cart and then checkout which creates an order.  They are able to add multiple items to their cart as well as remove items which are then returned to the merchants inventory.  Users can not add more items to their cart than what is in inventory.  If a visitor to the site wants to checkout they must register or login first.  Once a user has placed their order the status of the order changes, they receive a flash message confirming the order was created and their cart is then empty.  

## Orders 

The show template for this section is shared between users, merchants, and admins.  In this way we are able to DRY up some of our views.  Users are able to view their current orders and see information about the orders including the status of them.  They are also able to cancel an order as long as it has not been shipped.  Upon cancelling all inventory is returned to that item.  In implementing this each order was given a status recorded as an integer.  We then used the `enum` functionality within the order model to asign a string to each integer.  These values were: `pending`, `packaged`, `shipped`, or `cancelled`.  Merchants are able to fulfill items and the order status cahnges once all items have been fulfilled.  Admins are then able to see all orders in the system and are able to ship orders.

## Merchant Actions

A merchant is able login and see their information, a list of any pending orders that contain items they sell, as well as some statistics.  They can then view each order and are able to fulfill items for the order.  Through a different route using `namespacing` admins are also able to see all the same information as a merchant employee.  Admins are able to diable or enable merchants.  We added an `active?` attribute that was set to a default of `true` to merchants that we then used to enable or disable merchants.  Also through this action we were able to deactivate or activate all of the items belonging to that merchant at the same time.  So by disabling a merchant, a visitor or regular user would then not be able to see any of the items that belonged to that merchant.  Merchants themselves are able to activate or deactivate their items, add new items, edit items, and delete items.  When creating or editing items they must enter the information completely otherwise they will be redirected to the form and see a message specifying what they did not fill out correctly.  If they do not add a photo of an item then it is given a default image.

## Order Fulfillment

Merchants are able to fulfill each order for users which then changes the status of the order to `packaged`.  If the merchant does not have enough inventory then they cannot fulfill the order and receive a message saying so.

## Admin Actions

Admins are able to view all merchants and users and see their individual pages and see information about them.  In order to access these pages we used `namespacing` and `resources` to provide the correct routes for this navigation and make sure that only admins can use get there.  Also, with in the admin controllers we are able to use `before_action` to ensure that only admins are able access certain actions.  

## Next Time

One thing that we attempted, but were not able to implement was the ability to use images within the assets folder in our app.  This was specifically for the default image for an item.  We tried a few different ways, but in the end we couldn't spend more time on it and moved on.
