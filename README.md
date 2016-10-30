<h1>UltraBucket API</h1>

<a href="https://codeclimate.com/github/andela-ajamiu/ultralist"><img src="https://codeclimate.com/github/andela-ajamiu/ultralist/badges/gpa.svg" /></a> <a href="https://codeclimate.com/github/andela-ajamiu/ultralist"><img src="https://codeclimate.com/github/andela-ajamiu/ultralist/badges/issue_count.svg" /></a> <a href="https://codeclimate.com/github/andela-ajamiu/ultralist/coverage"><img src="https://codeclimate.com/github/andela-ajamiu/ultralist/badges/coverage.svg" /></a> [![Build Status](https://travis-ci.org/andela-ajamiu/ultralist.svg?branch=master)](https://travis-ci.org/andela-ajamiu/ultralist)

<h3>Overview</h3>

UltraBucket is an API that lets you manage your bucketlists. A bucket list is simply a number of experiences or achievements that a person hopes to have or accomplish during their lifetime.



<h3>Getting Started</h3>

Visit the UltraBucket <a href="https://ultrabucket.herokuapp.com">API Documentation</a>. It is clearly written and easy to understand and use.



<h3>External Dependencies</h3>

All the dependencies can be found in the <a href="https://github.com/andela-ajamiu/ultralist/blob/master/Gemfile">Gemfile.</a>



<h3>Available End Points</h3>
Below is the list of available endpoints in the BucketList API. Some end points are not available publicly and hence, can only be accessed when you sign up and log in.

<table>
<tr>
  <th>End Point</th>
  <th>Functionality</th>
  <th>Public Access</th>
</tr>

<tr>
  <td>POST /api/v1/users</td>
  <td>Create a new user</td>
  <td>TRUE</td>
</tr>

<tr>
  <td>POST /api/v1/auth/login</td>
  <td>Logs a user in</td>
  <td>TRUE</td>
</tr>

<tr>
  <td>GET /api/v1/auth/logged_in</td>
  <td>Shows the token status</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /api/v1/auth/logout</td>
  <td>Logs a user out</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>POST /api/v1/bucketlists</td>
  <td>Create a new bucketlist</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /api/v1/bucketlists</td>
  <td>List all the created bucketlists</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /bucketlists/:id</td>
  <td>Get a single bucketlist</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>PUT /bucketlists/:id</td>
  <td>Update this bucketlist</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>DELETE /bucketlists/:id</td>
  <td>Delete this single bucketlist</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>POST /bucketlists/:id/items</td>
  <td>Creates a new item in the bucketlist</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /bucketlists/:id/items</td>
  <td>Lists all items in the single bucketlist.</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /bucketlists/:id/items/:item_id</td>
  <td>Fetches a single bucketlist Item</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>PUT /bucketlists/:id/items/:item_id</td>
  <td>Updates a bucketlist item</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>DELETE /bucketlists/:id/items/:item_id</td>
  <td>Deletes an item in a bucketlist</td>
  <td>FALSE</td>
</tr>
</table>



<h3>JSON Data Model</h3>
A typical bucket list requested by a user would look like this:
<pre>
  {
    id: 1,
    name: “New Year Goals”,
    items: [
           {
               id: 1,
               name: “I am to do this before the end of this year”,
               done: false
             }
           ]
    created_by: “emjay”
}
</pre>



<h3> Pagination </h3>
The Bucketlist API comes with pagination by default, so the number of results to display to users can be specified when fetching the bucketlists, by supplying the <code>page</code> and <code>limit</code> params in the request to the API.

<h4>Example</h4>
<b>Request:</b>
<pre>
GET https://ultrabucket.herokuapp.com/api/v1/bucketlists?page=2&limit=20
</pre>

<b>Response:</b>
<pre>
20 bucket list records belonging to the logged in user starting from the 21st gets returned.
</pre>

<b>Searching by Name</b>
Users can search for a bucket list by using it's name as the search parameter when making a <code>GET</code> request to list the bucketlists.

<h4>Example</h4>

<b>Request:</b>
 <pre>
  GET https://ultrabucket.herokuapp.com/api/v1/bucketlists?q=bucket1
 </pre>

<b>Response:</b>
<pre>
This returns all bucketlists whose name contains "bucket1"
</pre>



<h3> Versions</h3>
UltraBucket API currently has only one version and can be accessed via this link - <a href="https://ultrabucket.herokuapp.com/api/v1/">https://ultrabucket.herokuapp.com/api/v1/</a>



<h3>Running Test</h3>
The Bucket List API uses `rspec` for testing. Continuous Integration is carried out via Travis CI.

To test locally, go through the following steps.

1. Clone the repo to your local machine.

  ```bash
  $  git clone git@github.com:andela-ajamiu/ultralist.git
  ```

2. `cd` into the `ultralist` folder.

  ```bash
  $  cd ultralist
  ```

3. Install dependencies

  ```bash
    $  bundle install
  ```

4. Set up and migrate the database.

  ```bash
  $ rake db:setup
  ```

5. Run the tests.

  ```bash
  $  bundle exec rspec
  ```


<h3>Limitations</h3>
This API is not rate limited and so users can overload the server through multiple requests