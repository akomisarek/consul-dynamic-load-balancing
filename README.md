# Requirements

In order to use this repo you need to have Vagrant and librarian-puppet installed.

* gem install librarian-puppet
* librarian-puppet install 
* Download [Vagrant](https://www.vagrantup.com/downloads.html)

# Running 

If you have everything installed you can create and provision boxes, just 
```
vagrant up
```

This will create 3 virtual machines - one server and two agents. 

The server has got haproxy installed on port 8000 which is configured using consul. You can test load balancing by doing 
```
curl localhost:8000
```

You should see Agent / Agent2 replies depending which backend is hit. 

# Known issues
You need to provision every time after booting the boxes - the firewall is not managed properly. Just run vagrant provision {server} or vagrant up {server} --provision and you should be good.

