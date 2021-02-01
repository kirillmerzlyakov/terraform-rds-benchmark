#! /bin/bash

sudo apt-get update
sudo apt-get install -y apache2 postgresql

cat <<EOF > /var/www/html/index.html
<html>
<h1>Start apache with Terraform</h1>
<br>
<h2>DB PostgreSQL start on:</h2>
<h3>host: <font color="red">${db_host}</font></h3>
<h3>port: <font color="red">${db_port}</font></h3>
<h3>db_name: <font color="red">${db_name}</font></h3>
<h3>db_username: <font color="red">${db_username}</font></h3>
<h3>db_password: <font color="red">${db_password}</font></h3>
<h3>db_allocated_storage: <font color="red">${db_allocated_storage} GB</font></h3>
</html>
EOF

sudo systemctl start apache2
sudo systemctl enable apache2

sudo wget https://github.com/TPC-Council/HammerDB/releases/download/v3.3/HammerDB-3.3-Linux-x86-64-Install
sudo chmod u+x HammerDB-3.3-Linux-x86-64-Install
sudo ./HammerDB-3.3-Linux-x86-64-Install

mkdir ./tpcc_tests

cat <<EOF > ./tpcc_tests/build_schema.tcl
#!/bin/tclsh

puts "SETTING CONFIGURATION"

global complete
proc wait_to_complete {} {
global complete
set complete [vucomplete]
if {!\$complete} {after 5000 wait_to_complete} else { exit }
}

dbset db pg
diset connection pg_host ${db_host}
diset connection pg_port ${db_port}
diset tpcc pg_count_ware 2
diset tpcc pg_num_vu 1
diset tpcc pg_superuser ${db_username}
diset tpcc pg_superuserpass ${db_password}
diset tpcc pg_defaultdbase ${db_name}
diset tpcc pg_user ${db_username}_1
diset tpcc pg_pass ${db_password}
diset tpcc pg_dbase ${db_name}
print dict
buildschema
wait_to_complete
EOF


cat <<EOF > ./tpcc_tests/run_tests.tcl
#!/bin/tclsh
proc runtimer { seconds } {
set x 0
set timerstop 0
while {!\$timerstop} {
incr x
after 1000
if { ![ expr {\$x % 60} ] } {
set y [ expr \$x / 60 ]
puts "Timer: $y minutes elapsed"
}
update
if { [ vucomplete ] || \$x eq \$seconds } { set timerstop 1 }
}
return
}

puts "SETTING CONFIGURATION"
dbset db pg
diset connection ${db_host}
diset connection pg_port ${db_port}
diset tpcc pg_superuser ${db_username}
diset tpcc pg_superuserpass ${db_password}
diset tpcc pg_defaultdbase ${db_name}
diset tpcc pg_user ${db_username}_1
diset tpcc pg_pass ${db_password}
diset tpcc pg_dbase ${db_name}
diset tpcc pg_driver timed
diset tpcc pg_duration 2
diset tpcc pg_duration 5
diset tpcc pg_vacuum true
print dict
vuset logtotemp 1
loadscript
puts "SEQUENCE STARTED"
foreach z { 1 16 32} {
puts "$z VU TEST"
vuset vu $z
vucreate
vurun
runtimer 10
vudestroy
after 5
}
puts "TEST SEQUENCE COMPLETE"
exit
EOF
